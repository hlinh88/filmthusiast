//
//  HomeSectionHeader.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit
import Reusable

class HomeSectionHeader: BaseHeaderCell {
    @IBOutlet weak var lbHeader: LabelRegular!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configHeader(with title: String) {
        lbHeader.text = title
    }

}
