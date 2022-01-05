//
//  MenuViewModel.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 13.11.21.
//

import Foundation

final class MenuViewModel {
    
    var isCameraAccessAuthorized: Bool {
        return cameraManager.isAccessAuthorized
    }
    
    var isCameraAccessNotDetermined: Bool {
        return cameraManager.isAccessNotDetermined
    }
    
    var isPhotoLibraryAccessAuthorized: Bool {
        return photoLibraryManager.isAccessAuthorized
    }
    
    var isPhotoLibraryAccessNotDetermined: Bool {
        return photoLibraryManager.isAccessNotDetermined
    }
    
    private let cameraManager = CameraManager.shared
    private let photoLibraryManager = PhotoLibraryManager.shared
    
    func requestCameraAccess(completion: @escaping (Bool) -> ()) {
        cameraManager.requestAccess(completion: completion)
    }
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> ()) {
        photoLibraryManager.requestAccess(completion: completion)
    }
}
