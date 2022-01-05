//
//  UIColor+Image.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 16.11.21.
//

import UIKit

extension UIColor {
    
    var image: UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { rendererContext in
            setFill()
            rendererContext.fill(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))
        }
    }
}
