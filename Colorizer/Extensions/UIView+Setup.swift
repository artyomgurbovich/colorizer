//
//  UIView+Setup.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 10.11.21.
//

import UIKit

extension UIView {
    
    func loadFromNib() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
    }
    
    func fixIn(_ container: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor),
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor),
            bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}
