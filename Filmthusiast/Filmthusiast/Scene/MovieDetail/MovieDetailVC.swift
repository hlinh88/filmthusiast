//
//  MovieDetailVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit
import SVProgressHUD
import ImageSlideshow

class MovieDetailVC: BaseVC {
    @IBOutlet weak var lbNavBar: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stvContent: UIStackView!

    var id: Int
    private var movie: Movie?
    private var genres: [Genre] = []
    private var casts: [MovieContentSectionModel] = []
    private var director: [String] = []
    private var writer: [String] = []
    private var recommendations: [MovieContentSectionModel] = []

    private var images: [KingfisherSource] = []

    init(withId id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        fetchMovieData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: Setup
    private func initView() {
    }

    private func setupUI() {
        lbNavBar.text = movie?.title

        setupMovieInfoSection()
        setupCastSection()
        setupRecommendations()

        SVProgressHUD.dismiss()
    }

    private func setupMovieInfoSection() {
        guard let movie = self.movie else { return }
        let movieInfoSection: MovieInfoSection = MovieInfoSection.fromNib()
        movieInfoSection.configMovieInfoSection(movie: movie, images: images, output: self)
        
        stvContent.addArrangedSubview(movieInfoSection)
    }
    
    private func setupCastSection() {
        let castSection: MovieContentSection = MovieContentSection.fromNib()
        castSection.configSection(sectionType: .Cast, 
                                  headerTitle: "Top Billed Cast",
                                  contents: casts,
                                  output: self)
        castSection.setupExtraInfo(title: "Director", descs: director)
        castSection.setupExtraInfo(title: "Writer", descs: writer)
        
        stvContent.addArrangedSubview(castSection)
    }
    
    private func setupRecommendations() {
        let recSection: MovieContentSection = MovieContentSection.fromNib()
        recSection.configSection(sectionType: .Recommendation,
                                  headerTitle: "More Like This",
                                  contents: recommendations,
                                  output: self)
        
        stvContent.addArrangedSubview(recSection)
    }

    // MARK: Interactor

    func fetchMovieData() {
        SVProgressHUD.show()
        let group = DispatchGroup()

        getMovieDetail(group)
        getMovieImages(group)
        getMovieCast(group)
        getMovieRecommendation(group)

        group.notify(queue: .main) { [weak self] in
            self?.setupUI()
        }
    }

    func getMovieDetail(_ group: DispatchGroup) {
        group.enter()
        let endpoint = String(format: APIEndpoint.MOVIE_DETAIL.DETAILS, String(id))
        APIService.shared.callAPI(urlString: endpoint) { [weak self] (result: Result<Movie, APIError>) in
            switch result {
            case .success(let movie):
                self?.movie = movie
                group.leave()

            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription, btnString: "OK")
            }
        }
    }

    func getMovieImages(_ group: DispatchGroup) {
        group.enter()
        let endpoint = String(format: APIEndpoint.MOVIE_DETAIL.IMAGES, String(id))
        APIService.shared.callAPI(urlString: endpoint) { [weak self] (result: Result<BackdropList, APIError>) in

            switch result {
            case .success(let backdrop):
                for backdrop in backdrop.backdrops {
                    guard let source = KingfisherSource(urlString: backdrop.filePath) else { return }
                    self?.images.append(source)
                }
                group.leave()

            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription, btnString: "OK")
            }
        }
    }

    func getMovieCast(_ group: DispatchGroup) {
        group.enter()
        let endpoint = String(format: APIEndpoint.MOVIE_DETAIL.CASTS, String(id))
        APIService.shared.callAPI(urlString: endpoint) { [weak self] (result: Result<CastList, APIError>) in

            switch result {
            case .success(let castList):
                for cast in castList.casts {
                    self?.casts.append(.init(id: cast.id,
                                             image: cast.profilePath,
                                             title: cast.name,
                                             desc: cast.character))
                    
                }

                let directorList = castList.crew.filter { $0.job == "Director" }
                directorList.forEach { self?.director.append($0.name) }

                let writerList = castList.crew.filter { $0.job == "Story" }
                writerList.forEach { self?.writer.append($0.name) }
                
                group.leave()

            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription, btnString: "OK")
            }
        }
    }
    
    func getMovieRecommendation(_ group: DispatchGroup) {
        group.enter()
        let endpoint = String(format: APIEndpoint.MOVIE_DETAIL.RECOMMENDATIONS, String(id))
        APIService.shared.callAPI(urlString: endpoint) { [weak self] (result: Result<MovieList, APIError>) in

            switch result {
            case .success(let movieList):
                for movie in movieList.results {
                    self?.recommendations.append(.init(id: movie.id,
                                                       image: movie.poster,
                                                       title: movie.title,
                                                       desc: ""))
                }
                group.leave()

            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription, btnString: "OK")
            }
        }
    }

    // MARK: Action

}

extension MovieDetailVC: MovieInfoSectionOutput {
    
}

extension MovieDetailVC: MovieContentSectionOutput {
    func didSelectCell(type: MovieContentSection.SectionType, content: MovieContentSectionModel) {
        switch type {
        case .Cast:
            print("Navigate to Cast info")
        case .Recommendation:
            let vc = MovieDetailVC(withId: content.id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
