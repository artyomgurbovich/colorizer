//
//  CameraAccessViewModel.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 8.11.21.
//

import Foundation

final class CameraAccessViewModel: AccessViewModel {
    
    private let cameraManager = CameraManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    
    func allowDidTapped(completion: @escaping () -> ()) {
        userDefaultsManager.isCameraAccessChecked = true
        cameraManager.requestAccess { success in
            completion()
        }
    }
    
    func skipDidTapped() {
        userDefaultsManager.isCameraAccessChecked = true
    }
}
