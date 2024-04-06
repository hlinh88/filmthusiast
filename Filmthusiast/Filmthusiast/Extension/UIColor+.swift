//
//  UIColor+.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 6/4/2024.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
           let normalizedRed = CGFloat(min(max(0, red), 255)) / 255.0
           let normalizedGreen = CGFloat(min(max(0, green), 255)) / 255.0
           let normalizedBlue = CGFloat(min(max(0, blue), 255)) / 255.0

           self.init(red: normalizedRed, green: normalizedGreen, blue: normalizedBlue, alpha: alpha)
       }

    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formattedString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedString = formattedString.replacingOccurrences(of: "#", with: "")

        guard formattedString.count == 6 else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: formattedString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
