//
//  NavigationView.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 10.11.21.
//

import UIKit

final class NavigationView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var onLeftTapped: (() -> ())?
    var onRightTapped: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    @IBAction func leftButtonTapped() {
        onLeftTapped?()
    }
    
    @IBAction func rightButtonTapped() {
        onRightTapped?()
    }
    
    private func setupUI() {
        loadFromNib()
        contentView.fixIn(self)
        contentView.layer.cornerRadius = 25
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "White")?.cgColor
        leftButton.layer.cornerRadius = 25
        leftButton.layer.borderWidth = 2
        leftButton.layer.borderColor = UIColor(named: "White")?.cgColor
        rightButton.layer.cornerRadius = 25
        rightButton.layer.borderWidth = 2
        rightButton.layer.borderColor = UIColor(named: "White")?.cgColor
    }
}
