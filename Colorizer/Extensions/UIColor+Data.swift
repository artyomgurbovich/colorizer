//
//  UIColor+Data.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 14.11.21.
//

import UIKit

extension UIColor {

     static func from(_ data: Data) -> UIColor? {
          return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
     }

     func encode() -> Data? {
          return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
     }
}
