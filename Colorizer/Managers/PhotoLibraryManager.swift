//
//  PhotoLibraryManager.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 9.11.21.
//

import Photos

final class PhotoLibraryManager {
    
    static let shared = PhotoLibraryManager()
    
    var isAccessAuthorized: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    var isAccessNotDetermined: Bool {
        return PHPhotoLibrary.authorizationStatus() == .notDetermined
    }

    private init() { }
    
    func requestAccess(completion: @escaping (Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
}
