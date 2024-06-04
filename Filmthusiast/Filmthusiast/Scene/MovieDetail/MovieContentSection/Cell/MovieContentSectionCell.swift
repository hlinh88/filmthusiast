//
//  MovieContentSectionCell.swift
//  Filmthusiast
//
//  Created by Luke Nguyen on 4/6/24.
//

import UIKit

class MovieContentSectionCell: BaseCVCell {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var ivContent: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(with model: MovieContentSectionModel) {
        ivContent.roundTopCorners(of: ivContent, radius: 10)
        ivContent.kf.setImage(with: URL(string: model.image))
        lbTitle.text = model.title
        lbDesc.text = model.desc
    }
}

