//
//  HomeShowcaseCell.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 3/4/2024.
//

import UIKit
import Kingfisher
import Reusable
import SkeletonView

class HomeShowcaseCell: BaseCVCell {
    @IBOutlet weak var vShadow: UIView!
    @IBOutlet weak var ivShowcase: UIImageView!
    @IBOutlet weak var vBlur: UIView!
    @IBOutlet weak var vSkeleton: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(with movie: Movie) {
        ivShowcase.kf.setImage(with: URL(string: movie.poster))
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
