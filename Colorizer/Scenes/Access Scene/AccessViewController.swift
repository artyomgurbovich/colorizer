//
//  AccessViewController.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 8.11.21.
//

import UIKit

final class AccessViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var viewModel: AccessViewModel!
    var image: UIImage?
    var text: String?
    var onChooseOption: (() -> ())?
    private let uiDevice = UIDevice.current
    private let uiScreen = UIScreen.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI()
    }
    
    @IBAction func allowButtonTapped() {
        viewModel.allowDidTapped {
            DispatchQueue.main.async {
                self.onChooseOption?()
            }
        }
    }
    
    @IBAction func skipTapped() {
        viewModel?.skipDidTapped()
        onChooseOption?()
    }
    
    private func setupUI() {
        imageView.image = image
        infoLabel.text = text
        allowButton.layer.cornerRadius = 25
        skipButton.layer.cornerRadius = 25
        skipButton.layer.borderColor = UIColor(named: "White")?.cgColor
        skipButton.layer.borderWidth = 2
    }
    
    private func updateUI() {
        if uiDevice.orientation.isPortrait {
            topConstraint.constant = 120
            imageHeightConstraint.constant = 160
            buttonsStackView.axis = .vertical
        } else if uiDevice.orientation.isLandscape {
            topConstraint.constant = 60
            imageHeightConstraint.constant = 80
            buttonsStackView.axis = .horizontal
        }
    }
}
