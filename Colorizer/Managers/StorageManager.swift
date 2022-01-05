//
//  StorageManager.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 14.11.21.
//

import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    private(set) var colorizedImages: [ColorizedImage]!
    private let context = AppDelegate.shared.persistentContainer.viewContext
    
    private init() {
        fetch()
    }
    
    func create(image: UIImage, colors: [UIColor]) {
        let colorizedImage = ColorizedImage(context: context)
        colorizedImage.imageData = image.jpegData(compressionQuality: 1.0)
        colorizedImage.colorsData = colors.compactMap{$0.encode()}
        colorizedImage.date = Date()
        update()
    }
    
    func remove(_ item: ColorizedImage) {
        context.delete(item)
        update()
    }
    
    private func fetch() {
        colorizedImages = try! context.fetch(ColorizedImage.fetchRequest())
    }
    
    private func save() {
        try! context.save()
    }
    
    private func update() {
        save()
        fetch()
    }
}
