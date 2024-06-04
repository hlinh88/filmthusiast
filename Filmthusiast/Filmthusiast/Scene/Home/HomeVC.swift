//
//  HomeVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit

class HomeVC: BaseVC {

    enum Section: CaseIterable {
        case Showcase
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming

        var title: String {
            switch self {
            case .NowPlaying:
                return "now_playing"
            case .Popular:
                return "popular"
            case .TopRated:
                return "top_rated"
            case .Upcoming:
                return "upcoming"
            default:
                return ""
            }
        }
    }

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var vBlur: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!

    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var upcomingMovies: [Movie] = []

    var showcaseMovie: Movie?

//    let sections: [Section] = [.Showcase, .NowPlaying, .Popular, .TopRated, .Upcoming]
    let sections: [Section] = [.Showcase, .TopRated]

    private var isLoadingData: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.getMovies()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: Setup
    private func setupUI() {
        setupTopBar()   
        setupCollectionView()
    }

    private func setupTopBar() {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        vBlur.layer.opacity = 0
        vBlur.effect = blur
        vBlur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupCollectionView() {
        collectionView.register(cellType: HomeMovieCell.self)
        collectionView.register(cellType: HomeShowcaseCell.self)
        collectionView.register(cellType: HomeSliderView.self)
        collectionView.register(supplementaryViewType: HomeSectionHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    }

    // MARK: Interactor
    func getMovies() {
        let group = DispatchGroup()

        Section.allCases.forEach { category in
            guard category != .Showcase else { return }

            group.enter()

            let endpoint = String(format: APIEndpoint.MOVIE_LISTS.CATEGORY, category.title)
            APIService.shared.callAPI(urlString: endpoint) { [weak self] (result: Result<MovieList, APIError>) in
                switch result {
                case .success(let movieList):
                    switch category {
                    case .NowPlaying:
                        self?.nowPlayingMovies = movieList.results
                    case .Popular:
                        self?.popularMovies = movieList.results
                    case .TopRated:
                        self?.topRatedMovies = movieList.results
                    case .Upcoming:
                        self?.upcomingMovies = movieList.results
                    default:
                        print("Do nothing")
                    }

                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription, btnString: "OK")
                }

                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.showcaseMovie = self?.topRatedMovies.first
            self?.isLoadingData = false
            self?.collectionView.reloadData()
        }

    }

    private func generateSkeletonMovies(numberOfMovies: Int) -> [Movie] {
        var movies: [Movie] = []

        for _ in 0..<numberOfMovies {
            let emptyMovie = Movie()
            movies.append(emptyMovie)
        }

        return movies
    }

}

extension HomeVC: UICollectionViewDataSource, 
                    UICollectionViewDelegate,
                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             for: indexPath,
                                                                             viewType: HomeSectionHeader.self)
            switch sections[indexPath.section] {
            case .Showcase:
                headerView.configHeader(with: "")
            case .NowPlaying:
                headerView.configHeader(with: "Now Playing")
            case .Popular:
                headerView.configHeader(with: "Popular")
            case .TopRated:
                headerView.configHeader(with: "Top Rated")
            case .Upcoming:
                headerView.configHeader(with: "Upcoming")
            }

            return headerView
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = collectionView.frame.width
        switch sections[section] {
        case .Showcase:
            return .zero
        default:
            return CGSize(width: width, height: 50)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        switch sections[indexPath.section] {
        case .Showcase:
            return CGSize(width: width, height: 500)
        default:
            return CGSize(width: width, height: 200)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeSliderView = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeSliderView.self)
        cell.output = self

        if isLoadingData {
            switch sections[indexPath.section] {
            case .Showcase:
                let cell: HomeShowcaseCell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeShowcaseCell.self)
                cell.configCell(with: Movie())
                cell.showSkeleton()

                return cell

            default:
                cell.configCell(with: generateSkeletonMovies(numberOfMovies: 5), isLoadingData: true)
            }
            
        } else {
            switch sections[indexPath.section] {
            case .Showcase:
                guard let showcaseMovie else { return UICollectionViewCell() }
                let cell: HomeShowcaseCell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeShowcaseCell.self)
                cell.configCell(with: showcaseMovie)
                cell.hideSkeleton()

                return cell

            case .NowPlaying:
                cell.configCell(with: nowPlayingMovies)
            case .Popular:
                cell.configCell(with: popularMovies)
            case .TopRated:
                cell.configCell(with: topRatedMovies)
            case .Upcoming:
                cell.configCell(with: upcomingMovies)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sections[indexPath.section] == .Showcase {
            guard let showcaseMovie else { return }
            let vc = MovieDetailVC(withId: showcaseMovie.id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y

        let maxOffset: CGFloat = 86
        let normalizedOffset = min(max(yOffset, 0), maxOffset)
        let opacity = normalizedOffset / maxOffset

        vBlur.alpha = opacity
    }

}

extension HomeVC: HomeSliderViewOutput {
    func goToMovieDetail(_ id: Int) {
        let vc = MovieDetailVC(withId: id)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
