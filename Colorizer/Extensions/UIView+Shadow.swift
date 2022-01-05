//
//  UIView+Shadow.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 26.11.21.
//

import UIKit

extension UIView {
    
    func addShadow(radius: CGFloat = 1, offset: CGSize = .zero) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(named: "Black")?.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
}
