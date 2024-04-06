//
//  GenreCell.swift
//  Filmthusiast
//
//  Created by Luke Nguyen on 05/04/2024.
//

import UIKit

class GenreCell: BaseCVCell {
    @IBOutlet weak var vGenre: UIView!
    @IBOutlet weak var lbGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(with genre: Genre) {
        lbGenre.text = genre.name
    }

}

