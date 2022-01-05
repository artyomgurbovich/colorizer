//
//  UIViewController+Alert.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 28.11.21.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String? = nil, message: String? = nil, actionTitle: String? = nil, handler: (() -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default) { _ in handler?() })
        present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertWithOptions(title: String? = nil, message: String? = nil, rightActionTitle: String, leftHandler: (() -> ())? = nil, rightHandler: @escaping () -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in leftHandler?() })
        alertController.addAction(UIAlertAction(title: rightActionTitle, style: .default) { _ in rightHandler() })
        present(alertController, animated: true, completion: nil)
    }
}
