//
//  RoundedSegmentedControl.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 16.11.21.
//

import UIKit

final class RoundedSegmentedControl: UISegmentedControl {

    var segmentInset = CGFloat.zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = selectedSegmentTintColor?.image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height / 2
        }
    }
}
