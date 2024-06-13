//
//  MovieContentExtraInfo.swift
//  Filmthusiast
//
//  Created by Luke Nguyen on 13/6/24.
//

import UIKit
import Reusable

class MovieContentExtraInfo: UIView, NibLoadable {
    @IBOutlet weak var lbTitle: RubikSemibold!
    @IBOutlet weak var lbDesc: RubikRegular!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configInfo(title: String, descs: [String]) {
        lbTitle.text = "\(title):"
        var finalDesc = ""
        for (index, desc) in descs.enumerated() {
            if index == descs.count - 1 {
                finalDesc.append("\(desc).")
            } else {
                finalDesc.append("\(desc), ")
            }
        }
        lbDesc.text = finalDesc
    }
}
