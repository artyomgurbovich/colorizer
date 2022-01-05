//
//  CollectionViewCell.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 16.11.21.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setColors(_ colors: [UIColor]) {
        stackView.removeAllArrangedSubviews()
        for color in colors {
            let colorView = UIView()
            colorView.backgroundColor = color
            stackView.addArrangedSubview(colorView)
        }
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            darkView.alpha = 0.5
            checkmarkView.isHidden = false
        } else {
            darkView.alpha = 0
            checkmarkView.isHidden = true
        }
    }
    
    private func setupUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: "White")?.cgColor
    }
}
