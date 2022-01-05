//
//  UIStackView+Remove.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 16.11.21.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        for arrangedSubview in arrangedSubviews {
            removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
}
