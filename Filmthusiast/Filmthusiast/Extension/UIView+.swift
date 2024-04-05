//
//  UIView+.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 3/4/2024.
//

import UIKit

extension UIView {
    func dropShadow(shadowColor: CGColor, shadowOffset: CGSize) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOpacity = 1
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = 2

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

}
