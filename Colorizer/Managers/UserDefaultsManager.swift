//
//  UserDefaultsManager.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 9.11.21.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    var isCameraAccessChecked: Bool {
        set {
            userDefaults.set(newValue, forKey: "isCameraAccessChecked")
        }
        get {
            userDefaults.bool(forKey: "isCameraAccessChecked")
        }
    }
    
    var isPhotoLibraryAccessChecked: Bool {
        set {
            userDefaults.set(newValue, forKey: "isPhotoLibraryAccessChecked")
        }
        get {
            userDefaults.bool(forKey: "isPhotoLibraryAccessChecked")
        }
    }
    
    private init() { }
}
