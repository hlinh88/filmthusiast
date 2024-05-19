//
//  MovieInfoSection.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 19/5/2024.
//

import UIKit
import ImageSlideshow

protocol MovieInfoSectionOutput: UIViewController {

}

class MovieInfoSection: UIView {
    @IBOutlet weak var vSlideshow: ImageSlideshow!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var stvGenre: UIStackView!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    weak var output: MovieInfoSectionOutput?

    func configMovieInfoSection(movie: Movie, images: [KingfisherSource], output: MovieInfoSectionOutput) {
        self.output = output

        lbTitle.text = movie.title
        if let releaseDate = movie.releaseDate {
            lbYear.text = "\(releaseDate.prefix(4))"
        }
        lbStatus.text = movie.status
        ivPoster.kf.setImage(with: URL(string: movie.poster))
        lbDesc.text = movie.overview

        if let genres = movie.genres {
            for genre in genres {
                let genreView: GenreCell = GenreCell.fromNib()
                genreView.configCell(with: genre)
                stvGenre.addArrangedSubview(genreView)
            }
        }

        setupSliderView(images: images)
    }

    private func setupSliderView(images: [KingfisherSource]) {
        vSlideshow.setImageInputs(images)
        vSlideshow.slideshowInterval = 3.0
        vSlideshow.zoomEnabled = true
        vSlideshow.contentScaleMode = .scaleAspectFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        vSlideshow.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func didTapImage() {
        guard let output else { return }
        vSlideshow.presentFullScreenController(from: output)
    }

}
