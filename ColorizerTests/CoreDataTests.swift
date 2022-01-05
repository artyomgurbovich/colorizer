//
//  CoreDataTests.swift
//  CoreDataTests
//
//  Created by Artyom Gurbovich on 29.10.21.
//

import XCTest
import CoreData

@testable import Colorizer

final class CoreDataTests: XCTestCase {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "Colorizer")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func testFetch() {
        let context = persistentContainer.viewContext
        let colorizedImage = ColorizedImage(context: persistentContainer.viewContext)
        let currentDate = Date()
        colorizedImage.date = currentDate
        colorizedImage.imageData = Data()
        colorizedImage.colorsData = [UIColor.black.encode()!]
        try! context.save()
        let result = try? context.fetch(ColorizedImage.fetchRequest())
        XCTAssertNotNil(result, "Result is nil")
        XCTAssertEqual(result!.count, 1)
        XCTAssertNotNil(result?.first, "First item is nil")
        XCTAssertEqual(result!.first!.date, currentDate)
        XCTAssertEqual(result!.first!.imageData, Data())
        XCTAssertEqual(result!.first!.colorsData, [UIColor.black.encode()!])
    }
}
