//
//  UIView+.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 3/4/2024.
//

import UIKit

extension UIView {
    func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
    }

    func roundCornerWithShadow(cornerRadius: CGFloat, shadowRadius: CGFloat, offsetX: CGFloat, offsetY: CGFloat, colour: UIColor, opacity: Float) {

        self.clipsToBounds = false

        let layer = self.layer
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY);
        layer.shadowColor = colour.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath

        let bColour = self.backgroundColor
        self.backgroundColor = nil
        layer.backgroundColor = bColour?.cgColor

    }

}
