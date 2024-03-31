//
//  HomeVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit
import Reusable
import Network

class HomeVC: UIViewController {
    enum Section: String, CaseIterable {
        case NowPlaying = "now_playing"
        case Popular = "popular"
        case TopRated = "top_rated"
        case Upcoming = "upcoming"
    }

    @IBOutlet weak var collectionView: UICollectionView!

    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var upcomingMovies: [Movie] = []

    let sections: [Section] = [.NowPlaying, .Popular, .TopRated, .Upcoming]

    private var isLoadingData: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.getMovies()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: Setup
    private func setupUI() {
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.register(cellType: HomeMovieCell.self)
        collectionView.register(cellType: HomeSliderView.self)
        collectionView.register(supplementaryViewType: HomeSectionHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: Interactor
    func getMovies() {
        let group = DispatchGroup()
        
        for category in Section.allCases {
            group.enter()

            let urlString = "https://api.themoviedb.org/3/movie/\(category.rawValue)?language=en-US&page=1"
            APIService.shared.callAPI(urlString: urlString) { [weak self] (result: Result<MovieList, APIError>) in
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
                    }

                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription, btnString: "OK")
                }

                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.isLoadingData = false
            self?.collectionView.reloadData()
        }

    }

    private func generateSkeletonMovies() -> [Movie] {
        var movies: [Movie] = []
        let fakeMovieItem = 5

        for _ in 0..<fakeMovieItem {
            let emptyMovie = Movie(id: 0, backdrop: "", title: "", overview: "", poster: "", releaseDate: nil, status: nil)
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

        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 200)
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
            cell.configCell(with: generateSkeletonMovies(), isLoadingData: true)
        } else {
            switch sections[indexPath.section] {
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

}

extension HomeVC: HomeSliderViewOutput {
    func goToMovieDetail(_ id: Int) {
        let vc = MovieDetailVC(id)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
