//
//  MovieDetailVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit
import Kingfisher
import SwiftyGif

class MovieDetailVC:  UIViewController {
    @IBOutlet weak var lbNavBar: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var ivBackdrop: UIImageView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var vLoading: UIView!
    @IBOutlet weak var ivLoading: UIImageView!
    
    var id: Int
    private var movie: Movie?
    private var isLoading: Bool = true

    init(_ id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: Setup
    private func setupUI() {
        guard let movie = self.movie, let releaseDate = movie.releaseDate else { return }
        lbNavBar.text = movie.title
        lbTitle.text = movie.title
        lbYear.text = "\(releaseDate.prefix(4))"
        lbStatus.text = movie.status
        ivBackdrop.kf.setImage(with: URL(string: "\(APIConstant.IMAGE_ORIGINAL_BASE_URL)\(movie.backdrop)"))
        ivPoster.kf.setImage(with: URL(string: "\(APIConstant.IMAGE_BASE_URL)\(movie.poster)"))
        lbDesc.text = movie.overview

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.hideLoading()
        }

    }

    private func showLoading() {
        vLoading.isHidden = false
        do {
            let gif = try UIImage(gifName: "loading.gif")
            self.ivLoading.setGifImage(gif, loopCount: -1)
        } catch {
            print("Error loading gif:", error.localizedDescription)
        }
    }

    private func hideLoading() {
        vLoading.isHidden = true
    }

    // MARK: Interactor

    func getMovieDetail() {
        showLoading()
        
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
