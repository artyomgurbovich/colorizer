//
//  PreviewViewController.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 15.11.21.
//

import UIKit

final class PreviewViewController: UIViewController {

    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var colorsStackView: UIStackView!
    
    var onClose: (() -> ())?
    var viewModel: PreviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupImageScrollView()
    }
    
    @IBAction func letfTapped() {
        let activityViewController = UIActivityViewController(activityItems: [viewModel.image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = leftButton
        present(activityViewController, animated: true)
    }
    
    @IBAction func rightTapped() {
        presentAlertWithOptions(title: "Delete Image",
                                     message: "Are you sure you want to delete image?",
                                     rightActionTitle: "Ok") {
            self.viewModel.delete()
            self.onClose?()
            self.dismiss(animated: true)
        }
    }
    
    private func setupUI() {
        setupNavigationView()
        setupBottomView()
    }
    
    private func setupNavigationView() {
        navigationView.titleLabel.text = "Preview"
        navigationView.leftButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        navigationView.rightButton.isHidden = true
        navigationView.onLeftTapped = {
            self.onClose?()
            self.dismiss(animated: true)
        }
    }
    
    private func setupImageScrollView() {
        imageScrollView.setImage(viewModel.image)
    }
    
    private func setupBottomView() {
        leftButton.layer.cornerRadius = 25
        leftButton.layer.borderWidth = 2
        leftButton.layer.borderColor = UIColor(named: "White")?.cgColor
        leftButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        rightButton.layer.cornerRadius = 25
        rightButton.layer.borderWidth = 2
        rightButton.layer.borderColor = UIColor(named: "White")?.cgColor
        rightButton.setImage(UIImage(systemName: "trash"), for: .normal)
        colorsStackView.layer.cornerRadius = 10
        colorsStackView.layer.borderWidth = 1
        colorsStackView.layer.borderColor = UIColor(named: "White")?.cgColor
        for color in viewModel.colors {
            let colorView = UIView()
            colorView.backgroundColor = color
            colorsStackView.addArrangedSubview(colorView)
        }
    }
}
