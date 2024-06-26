//
//  HomeMovieCell.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit
import Kingfisher
import Reusable
import SkeletonView

class HomeMovieCell: BaseCVCell {
    @IBOutlet weak var ivBanner: UIImageView!
    @IBOutlet weak var vSkeleton: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(with movie: Movie) {
        ivBanner.kf.setImage(with: URL(string: movie.poster))
    }

    func showSkeleton() {
        DispatchQueue.main.async { [weak self] in
            self?.vSkeleton.isHidden = false
            self?.vSkeleton.showAnimatedGradientSkeleton()
        }
    }

    func hideSkeleton() {
        DispatchQueue.main.async { [weak self] in
            self?.vSkeleton.isHidden = true
            self?.vSkeleton.hideSkeleton()
        }
    }

}
