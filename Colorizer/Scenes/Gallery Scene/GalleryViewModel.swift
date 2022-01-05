//
//  GalleryViewModel.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 14.11.21.
//

import UIKit

final class GalleryViewModel {
    
    var colorizedImagesCount: Int {
        return currentColorizedImages.count
    }
    
    var isSortAscending = true {
        didSet {
            update()
        }
    }
    
    var isAllSelected: Bool {
        return selectedColorizedImages.count == currentColorizedImages.count
    }
    
    var selectedImages: [UIImage] {
        return currentColorizedImages.filter{selectedColorizedImages.contains($0)}.compactMap{UIImage(data: $0.imageData!)}
    }
    
    private var currentColorizedImages: [ColorizedImage]!
    private var selectedColorizedImages = Set<ColorizedImage>()
    private let storageManager = StorageManager.shared
    
    init() {
        update()
    }
    
    func update() {
        currentColorizedImages = storageManager.colorizedImages.sorted { lhs, rhs in
            return isSortAscending ? lhs > rhs : lhs < rhs
        }
    }
    
    func getImage(at index: Int) -> UIImage? {
        return UIImage(data: currentColorizedImages[index].imageData!)
    }
    
    func getColors(at index: Int) -> [UIColor] {
        return currentColorizedImages[index].colorsData!.compactMap{UIColor.from($0)}
    }
    
    func getIndexWithoutSort(_ index: Int) -> Int {
        for i in 0..<storageManager.colorizedImages.count {
            guard storageManager.colorizedImages[i] == currentColorizedImages[index] else { continue }
            return i
        }
        return 0
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedColorizedImages.contains(currentColorizedImages[index])
    }
    
    func select(at index: Int) {
        if isSelected(at: index) {
            selectedColorizedImages.remove(currentColorizedImages[index])
        } else {
            selectedColorizedImages.insert(currentColorizedImages[index])
        }
    }
    
    func selectAll(_ select: Bool) {
        if select {
            selectedColorizedImages = Set(currentColorizedImages)
        } else {
            selectedColorizedImages.removeAll()
        }
    }
    
    func deleteSelected() {
        selectedColorizedImages.forEach{storageManager.remove($0)}
        selectedColorizedImages.removeAll()
        update()
    }
}
