//
//  CameraManager.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 9.11.21.
//

import AVFoundation

final class CameraManager {
    
    static let shared = CameraManager()
    
    var isAccessAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    var isAccessNotDetermined: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
    }
    
    private init() { }
    
    func requestAccess(completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}
