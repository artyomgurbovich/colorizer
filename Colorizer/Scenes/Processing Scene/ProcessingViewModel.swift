//
//  ProcessingViewModel.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 14.11.21.
//

import UIKit

final class ProcessingViewModel {
    
    var image: UIImage?
    var link: String?
    var onCreateColorizedImage: ((Int?) -> ())?
    var onNewStage: ((Int) -> ())?
    private let colorizationManager = ColorizationManager.shared
    private let paletteManager = PaletteManager.shared
    private let storageManager = StorageManager.shared
    
    func startProcessing() {
        onNewStage?(0)
        if let image = image {
            colorizationManager.create(from: image) { link in
                self.onNewStage?(1)
                self.checkAndGetPaletteAndSave(colorizedImageLink: link)
            }
        } else if let link = link {
            colorizationManager.create(from: link) { link in
                self.onNewStage?(1)
                self.checkAndGetPaletteAndSave(colorizedImageLink: link)
            }
        }
    }
    
    private func checkAndGetPaletteAndSave(colorizedImageLink: String?) {
        guard let link = colorizedImageLink,
              let url = URL(string: link),
              let data = try? Data(contentsOf: url),
              let colorizedImage = UIImage(data: data) else {
            onCreateColorizedImage?(nil)
            return
        }
        paletteManager.create(from: link) { colors in
            guard let colors = colors else {
                self.onCreateColorizedImage?(nil)
                return
            }
            self.onNewStage?(2)
            self.storageManager.create(image: colorizedImage, colors: colors)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.onCreateColorizedImage?(self.storageManager.colorizedImages.count - 1)
            }
        }
    }
}
