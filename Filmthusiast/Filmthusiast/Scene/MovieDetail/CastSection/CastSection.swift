//
//  CastSection.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 19/5/2024.
//

import UIKit

class CastSection: UIView {
    @IBOutlet weak var movieDetailHeader: MovieDetailHeader!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCastSection() {
        movieDetailHeader.configHeader(with: "Cast")
    }


}
