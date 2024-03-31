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

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        setupUI()
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

        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(APIConstant.ACCESS_TOKEN)"
        ]

        for category in Section.allCases {
            group.enter()

            let urlString = "https://api.themoviedb.org/3/movie/\(category.rawValue)?language=en-US&page=1"
            APIService.shared.callAPI(urlString: urlString, headers: headers) { [weak self] (result: Result<MovieList, APIError>) in
                defer {
                    group.leave()
                }

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
                    print("API Error: \(error)")
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.collectionView.reloadData()
        }

    }

}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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

        return cell
    }


}
