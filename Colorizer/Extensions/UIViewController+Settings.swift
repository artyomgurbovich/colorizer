//
//  UIViewController+Settings.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 28.11.21.
//

import UIKit

extension UIViewController {
    
    func openSettingsApp() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                                UIApplication.shared.canOpenURL(settingsUrl) else { return }
        UIApplication.shared.open(settingsUrl)
    }
}
