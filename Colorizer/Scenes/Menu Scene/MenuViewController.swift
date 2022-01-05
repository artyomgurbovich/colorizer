//
//  MenuViewController.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 10.11.21.
//

import UIKit

final class MenuViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var segmentedControl: RoundedSegmentedControl!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet var stackViews: [UIStackView]!
    @IBOutlet var titleLabels: [UILabel]!
    
    var viewModel: MenuViewModel!
    var onCameraTapped: (() -> ())?
    var onPhotosTapped: (() -> ())?
    var onFilesTapped: (() -> ())?
    var onLinkTapped: (() -> ())?
    var onGalleryTapped: (() -> ())?
    private let uiDevice = UIDevice.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControl.isUserInteractionEnabled = true
        setLoadingState(false)
        updateUI()
    }
    
    @IBAction func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 1 {
            segmentedControl.isUserInteractionEnabled = false
            segmentedControl.selectedSegmentIndex = 0
            onGalleryTapped?()
        }
    }
    
    private func setupUI() {
        setupNavigationView()
        setupStackViews()
        setupSegmentedControl()
    }
    
    private func setupNavigationView() {
        navigationView.titleLabel.text = "Main"
        navigationView.leftButton.isHidden = true
        navigationView.rightButton.isHidden = true
    }
    
    private func setupStackViews() {
        stackViews[0].backgroundColor = viewModel.isCameraAccessAuthorized ? UIColor(named: "White") : UIColor(named: "Gray")
        stackViews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraViewTapped)))
        stackViews[1].backgroundColor = viewModel.isPhotoLibraryAccessAuthorized ? UIColor(named: "White") : UIColor(named: "Gray")
        stackViews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photosViewTapped)))
        stackViews[2].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filesViewTapped)))
        stackViews[3].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkViewTapped)))
    }
    
    private func setupSegmentedControl() {
        let font = UIFont(name: "Roboto-Medium", size: 24)!
        segmentedControl.layer.borderWidth = 2
        segmentedControl.segmentInset = 8
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentTintColor = .white
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    @objc private func cameraViewTapped() {
        setLoadingState(true)
        if viewModel.isCameraAccessAuthorized {
            onCameraTapped?()
        } else if viewModel.isCameraAccessNotDetermined {
            viewModel.requestCameraAccess { success in
                guard success else {
                    self.setLoadingState(false)
                    return
                }
                self.stackViews[0].backgroundColor = UIColor(named: "White")
                self.onCameraTapped?()
            }
        } else {
            setLoadingState(false)
            presentAlertWithOptions(title: "\"Colorizer\" Would Like to Acess the Camera",
                                    message: "Allow camera usage to take photos for colorization within the app.",
                                    rightActionTitle: "Settings") {
                self.openSettingsApp()
            }
        }
    }
    
    @objc private func photosViewTapped() {
        setLoadingState(true)
        if viewModel.isPhotoLibraryAccessAuthorized {
            onPhotosTapped?()
        } else if viewModel.isPhotoLibraryAccessNotDetermined {
            viewModel.requestPhotoLibraryAccess { success in
                guard success else {
                    self.setLoadingState(false)
                    return
                }
                self.stackViews[1].backgroundColor = UIColor(named: "White")
                self.onPhotosTapped?()
            }
        } else {
            setLoadingState(false)
            presentAlertWithOptions(title: "\"Colorizer\" Would Like to Acess Your Photos",
                                    message: "Allow photo library usage to pick photos for colorization from the Photos app.",
                                    rightActionTitle: "Settings") {
                self.openSettingsApp()
            }
        }
    }
    
    @objc private func filesViewTapped() {
        setLoadingState(true)
        onFilesTapped?()
    }
    
    @objc private func linkViewTapped() {
        setLoadingState(true)
        onLinkTapped?()
    }
    
    private func updateUI() {
        if uiDevice.orientation.isPortrait {
            for i in 0..<4 {
                stackViews[i].axis = .vertical
                stackViews[i].spacing = 25
                stackViews[i].layoutMargins = UIEdgeInsets(top: 25, left: 25, bottom: 30, right: 25)
                titleLabels[i].textAlignment = .center
            }
        } else if uiDevice.orientation.isLandscape {
            for i in 0..<4 {
                stackViews[i].axis = .horizontal
                stackViews[i].spacing = 15
                stackViews[i].layoutMargins = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
                titleLabels[i].textAlignment = .left
            }
        }
        stackViews.forEach{$0.layer.cornerRadius = $0.bounds.height > 50 ? 25 : $0.bounds.height / 2}
    }
    
    func setHiddenState(_ hidden: Bool) {
        navigationView.isHidden = hidden
        for stackView in stackViews {
            stackView.isHidden = hidden
        }
        segmentedControl.isHidden = hidden
    }
    
    private func setLoadingState(_ loading: Bool) {
        let newAlpha = loading ? 0.5 : 1.0
        navigationView.isUserInteractionEnabled = !loading
        navigationView.alpha = newAlpha
        for stackView in stackViews {
            stackView.isUserInteractionEnabled = !loading
            stackView.alpha = newAlpha
        }
        segmentedControl.isUserInteractionEnabled = !loading
        segmentedControl.alpha = newAlpha
    }
}
