//
//  MovieDetailHeader.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 6/4/2024.
//

import UIKit
import Reusable

class MovieDetailHeader: UIView, NibLoadable {
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configHeader(with title: String) {
        lbTitle.text = title
    }
}
