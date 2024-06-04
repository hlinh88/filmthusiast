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

    private var images: [KingfisherSource] = []

    init(_ id: Int) {
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
                                  headerTitle: "Casts",
                                  contents: casts,
                                  output: self)
        
        stvContent.addArrangedSubview(castSection)
    }

    // MARK: Interactor

    func fetchMovieData() {
        SVProgressHUD.show()
        let group = DispatchGroup()

        getMovieDetail(group)
        getMovieImages(group)
        getMovieCast(group)

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
                    self?.casts.append(.init(image: cast.profilePath,
                                             title: cast.name,
                                             desc: cast.character))
                }
                group.leave()

            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription, btnString: "OK")
            }
        }
    }

    // MARK: Action
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension MovieDetailVC: MovieInfoSectionOutput {
    
}

extension MovieDetailVC: MovieContentSectionOutput {
    func didSelectCell(type: MovieContentSection.SectionType, content: MovieContentSectionModel) {
        switch type {
        case .Cast:
            print("Navigate to Cast info")
        }
    }
}
