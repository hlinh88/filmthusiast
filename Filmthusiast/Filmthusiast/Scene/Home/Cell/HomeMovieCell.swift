//
//  HomeMovieCell.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit
import Kingfisher
import Reusable

class HomeMovieCell: BaseCVCell {

    @IBOutlet weak var ivBanner: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell() {
        ivBanner.layer.cornerRadius = 10
    }

    func configCell(with movie: Movie) {
        ivBanner.kf.setImage(with: URL(string: "\(APIConstant.IMAGE_BASE_URL)\(movie.poster)"))
    }

}
