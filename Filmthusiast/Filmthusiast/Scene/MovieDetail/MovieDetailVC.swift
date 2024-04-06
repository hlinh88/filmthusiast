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
    enum Section: CaseIterable {
        case Cast
    }

    @IBOutlet weak var lbNavBar: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var vSlideshow: ImageSlideshow!
    @IBOutlet weak var vGradient: UIView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var clvGenres: UICollectionView!
    @IBOutlet weak var clvContent: UICollectionView!
    
    var id: Int
    private var movie: Movie?
    private var genres: [Genre] = [] {
        didSet {
            clvGenres.reloadData()
        }
    }
    private var images: [KingfisherSource] = []
    let sections: [Section] = [.Cast]

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
        setupCollectionView()
    }

    private func setupCollectionView() {
        clvGenres.register(cellType: GenreCell.self)
        clvGenres.delegate = self
        clvGenres.dataSource = self
        if let flowLayout = clvGenres.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        clvContent.register(supplementaryViewType: MovieDetailHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        clvContent.delegate = self
        clvContent.dataSource = self
    }

    private func setupUI() {
        guard let movie = self.movie, let releaseDate = movie.releaseDate else { return }
        lbNavBar.text = movie.title
        lbTitle.text = movie.title
        lbYear.text = "\(releaseDate.prefix(4))"
        lbStatus.text = movie.status
        ivPoster.kf.setImage(with: URL(string: movie.poster))
        lbDesc.text = movie.overview
        genres = movie.genres ?? []

        setupSliderView()

        SVProgressHUD.dismiss()
    }

    private func setupSliderView() {
        vSlideshow.setImageInputs(images)
        vSlideshow.slideshowInterval = 3.0
        vSlideshow.zoomEnabled = true
        vSlideshow.contentScaleMode = .scaleAspectFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        vSlideshow.addGestureRecognizer(gestureRecognizer)
    }

    @objc func didTapImage() {
        vSlideshow.presentFullScreenController(from: self)
    }

    // MARK: Interactor

    func fetchMovieData() {
        SVProgressHUD.show()
        let group = DispatchGroup()

        getMovieDetail(group)
        getMovieImages(group)

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

    // MARK: Action
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case clvContent:
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 for: indexPath,
                                                                                 viewType: MovieDetailHeader.self)
                switch sections[indexPath.section] {
                case .Cast:
                    headerView.configHeader(with: "Cast")
                }

                return headerView
            }

        default:
            return UICollectionReusableView()

        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView {
        case clvContent:
            let width = collectionView.frame.width
            return CGSize(width: width, height: 44)
        default:
            return .zero
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case clvContent:
            return sections.count
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case clvContent:
            return 0
        case clvGenres:
            return genres.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case clvGenres:
            let cell: GenreCell = collectionView.dequeueReusableCell(for: indexPath, cellType: GenreCell.self)
            cell.configCell(with: genres[indexPath.row])

            return cell

        default:
            return UICollectionViewCell()
        }

    }

}
