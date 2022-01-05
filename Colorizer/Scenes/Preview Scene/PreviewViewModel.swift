//
//  PreviewViewModel.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 15.11.21.
//

import Foundation
import UIKit

final class PreviewViewModel {
    
    var image: UIImage!
    var colors: [UIColor]!
    private var colorizedImage: ColorizedImage!
    private let storageManager = StorageManager.shared
    
    init(index: Int) {
        colorizedImage = storageManager.colorizedImages[index]
        image = UIImage(data: (colorizedImage.imageData!))
        colors = colorizedImage.colorsData?.compactMap{UIColor.from($0)}
    }
    
    func delete() {
        storageManager.remove(colorizedImage)
    }
}
