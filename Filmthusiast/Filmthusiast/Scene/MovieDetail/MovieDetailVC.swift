//
//  MovieDetailVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit
import Kingfisher
import SwiftyGif
import SVProgressHUD

class MovieDetailVC: BaseVC {
    @IBOutlet weak var lbNavBar: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var ivBackdrop: UIImageView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var clvGenres: UICollectionView!
    
    var id: Int
    private var movie: Movie?
    private var genres: [Genre] = [] {
        didSet {
            clvGenres.reloadData()
        }
    }

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
        getMovieDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: Setup
    private func initView() {
        clvGenres.register(cellType: GenreCell.self)
        clvGenres.delegate = self
        clvGenres.dataSource = self
    }
    
    private func setupUI() {
        guard let movie = self.movie, let releaseDate = movie.releaseDate else { return }
        lbNavBar.text = movie.title
        lbTitle.text = movie.title
        lbYear.text = "\(releaseDate.prefix(4))"
        lbStatus.text = movie.status
        ivBackdrop.kf.setImage(with: URL(string: movie.backdrop))
        ivPoster.kf.setImage(with: URL(string: movie.poster))
        lbDesc.text = movie.overview
        genres = movie.genres ?? []
        
        SVProgressHUD.dismiss()
    }

    // MARK: Interactor

    func getMovieDetail() {
        SVProgressHUD.show()

        let urlString = "https://api.themoviedb.org/3/movie/\(id)"
        APIService.shared.callAPI(urlString: urlString) { [weak self] (result: Result<Movie, APIError>) in

            switch result {
            case .success(let movie):
                self?.movie = movie
                DispatchQueue.main.async {
                    self?.setupUI()
                }
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GenreCell = collectionView.dequeueReusableCell(for: indexPath, cellType: GenreCell.self)
        cell.configCell(with: genres[indexPath.row])

        return cell
    }

}
