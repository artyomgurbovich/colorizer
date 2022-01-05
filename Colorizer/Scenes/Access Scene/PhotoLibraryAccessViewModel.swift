//
//  PhotoLibraryAccessViewModel.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 10.11.21.
//

import Foundation

final class PhotoLibraryAccessViewModel: AccessViewModel {
    
    private let photoLibraryManager = PhotoLibraryManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    
    func allowDidTapped(completion: @escaping () -> ()) {
        userDefaultsManager.isPhotoLibraryAccessChecked = true
        photoLibraryManager.requestAccess { success in
            completion()
        }
    }
    
    func skipDidTapped() {
        userDefaultsManager.isPhotoLibraryAccessChecked = true
    }
}
