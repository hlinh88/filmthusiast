//
//  BaseLabelFont.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import Foundation
import UIKit

class LabelRegular: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyRegularFont()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyRegularFont()
    }

    private func applyRegularFont() {
        guard let customFont = UIFont(name: "BebasNeue-Regular", size: 17) else {
            fatalError("""
                Failed to load the font.
                """
            )
        }
        self.font = customFont
    }
}

class LabelBold: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyRegularFont()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyRegularFont()
    }

    private func applyRegularFont() {
        guard let customFont = UIFont(name: "BebasNeue-Bold", size: 30) else {
            fatalError("""
                Failed to load the font.
                """
            )
        }
        self.font = customFont
    }
}
