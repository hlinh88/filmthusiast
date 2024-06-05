//
//  ThemeManager.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import Foundation
import UIKit

class BaseFontLabel: UILabel {
    private var _size: CGFloat = 18.0

    @IBInspectable var size: CGFloat {
        get {
            return self.font.pointSize
        }
        set(newValue) {
            applyFont(size: newValue)
        }
    }

    var fontName: String {
        fatalError("Must override `fontName` in subclass.")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyFont(size: _size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyFont(size: _size)
    }

    private func applyFont(size: CGFloat) {
        guard let customFont = UIFont(name: fontName, size: size) else {
            fatalError("Failed to load the font \(fontName).")
        }
        self.font = customFont
    }
}

class Kenyc: BaseFontLabel {
    override var fontName: String {
        return "Kenyc"
    }
}

class BebasNeueBold: BaseFontLabel {
    override var fontName: String {
        return "BebasNeue-Bold"
    }
}

class RubikRegular: BaseFontLabel {
    override var fontName: String {
        return "Rubik-Regular"
    }
}

class RubikMedium: BaseFontLabel {
    override var fontName: String {
        return "Rubik-Medium"
    }
}

class RubikSemibold: BaseFontLabel {
    override var fontName: String {
        return "Rubik-Semibold"
    }
}

class RubikBold: BaseFontLabel {
    override var fontName: String {
        return "Rubik-Bold"
    }
}
