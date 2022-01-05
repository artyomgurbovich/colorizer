//
//  UIColor+Hex.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 15.11.21.
//

import UIKit

extension UIColor {
    
    convenience init(from hex: String) {
        var rgbValue: UInt64 = 0
        Scanner(string: String(hex.dropFirst())).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
}
