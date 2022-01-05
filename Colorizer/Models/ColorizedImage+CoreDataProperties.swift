//
//  ColorizedImage+CoreDataProperties.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 14.11.21.
//
//

import Foundation
import CoreData

extension ColorizedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorizedImage> {
        return NSFetchRequest<ColorizedImage>(entityName: "ColorizedImage")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var date: Date?
    @NSManaged public var colorsData: [Data]?
}

extension ColorizedImage: Identifiable {

}

extension ColorizedImage: Comparable {
    public static func < (lhs: ColorizedImage, rhs: ColorizedImage) -> Bool {
        return lhs.date! < rhs.date!
    }
}
