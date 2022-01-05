//
//  AppCoordinator.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 10.11.21.
//

import UIKit
import MobileCoreServices

final class AppCoordinator: NSObject {
    
    private let navigationController: UINavigationController
    private let tabBarController = UITabBarController()
    private var menuViewController: MenuViewController!
    private var galleryViewController: GalleryViewController!
    private let userDefaultsManager = UserDefaultsManager.shared
    
    init(navigationController: UINavigationController) {
        navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController = navigationController
        tabBarController.tabBar.isHidden = true
    }
    
    func start() {
        if !userDefaultsManager.isCameraAccessChecked {
            startCameraAccessScene()
        } else if !userDefaultsManager.isPhotoLibraryAccessChecked {
            startPhotoLibraryAccessScene()
        } else {
            startMenuAndGalleryScenes()
        }
    }
    
    private func startCameraAccessScene() {
        let accessViewController = AccessViewController()
        accessViewController.image = UIImage(named: "Camera")
        accessViewController.text = "Allow camera usage to take photos for colorization within the app."
        accessViewController.viewModel = CameraAccessViewModel()
        accessViewController.onChooseOption = {
            self.startPhotoLibraryAccessScene()
        }
        navigationController.pushViewController(accessViewController, animated: true)
    }
    
    private func startPhotoLibraryAccessScene() {
        let accessViewController = AccessViewController()
        accessViewController.image = UIImage(named: "Photo")
        accessViewController.text = "Allow photo library usage to pick photos for colorization from the Photos app."
        accessViewController.viewModel = PhotoLibraryAccessViewModel()
        accessViewController.onChooseOption = {
            self.startMenuAndGalleryScenes()
        }
        navigationController.pushViewController(accessViewController, animated: true)
    }
    
    private func startMenuAndGalleryScenes() {
        if menuViewController == nil {
            setupMenuViewController()
        }
        if galleryViewController == nil {
            setupGalleryViewController()
        }
        tabBarController.viewControllers = [menuViewController, galleryViewController]
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func startImagePickerScene(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = delegate
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle = .fullScreen
        navigationController.present(imagePickerController, animated: true)
    }
    
    private func startDocumentPickerScene(delegate: UIDocumentPickerDelegate) {
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypeImage)], in: .import)
        documentPickerViewController.delegate = delegate
        documentPickerViewController.allowsMultipleSelection = false
        documentPickerViewController.modalPresentationStyle = .fullScreen
        navigationController.present(documentPickerViewController, animated: true)
    }
    
    private func startLinkScene(delegate: LinkPickerDelegate) {
        let linkViewController = LinkPickerViewController()
        linkViewController.delegate = delegate
        linkViewController.modalPresentationStyle = .fullScreen
        navigationController.present(linkViewController, animated: true)
    }
    
    private func startProcessingScene(image: UIImage? = nil, link: String? = nil) {
        let processingViewController = ProcessingViewController()
        let processingViewModel = ProcessingViewModel()
        processingViewModel.image = image
        processingViewModel.link = link
        processingViewModel.onCreateColorizedImage = { colorizedImageIndex in
            DispatchQueue.main.async {
                guard let index = colorizedImageIndex else { return }
                self.menuViewController.setHiddenState(true)
                self.navigationController.popViewController(animated: false)
                self.startPreviewScene(index: index) {
                    self.menuViewController.setHiddenState(false)
                }
            }
        }
        processingViewController.viewModel = processingViewModel
        navigationController.pushViewController(processingViewController, animated: false)
    }
    
    private func startPreviewScene(index: Int, completion: (() -> ())? = nil) {
        let previewViewController = PreviewViewController()
        previewViewController.viewModel = PreviewViewModel(index: index)
        previewViewController.onClose = completion
        previewViewController.modalPresentationStyle = .fullScreen
        navigationController.present(previewViewController, animated: true)
    }
    
    private func setupMenuViewController() {
        menuViewController = MenuViewController()
        menuViewController.viewModel = MenuViewModel()
        menuViewController.onCameraTapped = {
            self.startImagePickerScene(delegate: self, sourceType: .camera)
        }
        menuViewController.onPhotosTapped = {
            self.startImagePickerScene(delegate: self, sourceType: .photoLibrary)
        }
        menuViewController.onFilesTapped = {
            self.startDocumentPickerScene(delegate: self)
        }
        menuViewController.onLinkTapped = {
            self.startLinkScene(delegate: self)
        }
        menuViewController.onGalleryTapped = {
            self.tabBarController.selectedViewController = self.galleryViewController
        }
        let _ = menuViewController.view
    }
    
    private func setupGalleryViewController() {
        galleryViewController = GalleryViewController()
        galleryViewController.viewModel = GalleryViewModel()
        galleryViewController.onMenuTapped = {
            self.tabBarController.selectedViewController = self.menuViewController
        }
        galleryViewController.onPreview = { colorizedImageIndex in
            self.startPreviewScene(index: colorizedImageIndex)
        }
        let _ = galleryViewController.view
    }
}

extension AppCoordinator: UINavigationControllerDelegate { }

extension AppCoordinator: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        defer { picker.dismiss(animated: true) }
        guard let image = info[.editedImage] as? UIImage else { return }
        startProcessingScene(image: image)
    }
}

extension AppCoordinator: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        defer { controller.dismiss(animated: true) }
        guard let firstURL = urls.first, let data = try? Data(contentsOf: firstURL), let image = UIImage(data: data) else { return }
        startProcessingScene(image: image)
    }
}

extension AppCoordinator: LinkPickerDelegate {
    func linkPicker(_ controller: LinkPickerViewController, didPickLink link: String) {
        defer { controller.dismiss(animated: true) }
        startProcessingScene(link: link)
    }
}
