//
//  GalleryViewController.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 14.11.21.
//

import UIKit

final class GalleryViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectionView: NavigationView!
    @IBOutlet weak var segmentedControl: RoundedSegmentedControl!
    
    var onMenuTapped: (() -> ())?
    var onPreview: ((Int) -> ())?
    var viewModel: GalleryViewModel!
    private var inSelectionMode = false
    private let uiScreen = UIScreen.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControl.isUserInteractionEnabled = true
        viewModel.update()
        updateUI()
    }
    
    @IBAction func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            segmentedControl.isUserInteractionEnabled = false
            segmentedControl.selectedSegmentIndex = 1
            onMenuTapped?()
        }
    }
    
    private func setupUI() {
        setupNavigationView()
        setupCollectionView()
        setupSegmentControl()
        setupSelectionView()
    }
    
    private func setupNavigationView() {
        navigationView.titleLabel.text = "Gallery"
        navigationView.leftButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        navigationView.rightButton.setImage(UIImage(named: "Checkmark"), for: .normal)
        navigationView.onLeftTapped = leftTapped
        navigationView.onRightTapped = rightTapped
        navigationView.addShadow(radius: 10, offset: CGSize(width: 0, height: 10))
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = ((uiScreen.nativeBounds.width / uiScreen.nativeScale) - 90) / 2
        layout.sectionInset = UIEdgeInsets(top: 55, left: 0, bottom: 55, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 27)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupSegmentControl() {
        let font = UIFont(name: "Roboto-Medium", size: 24)!
        segmentedControl.layer.borderWidth = 2
        segmentedControl.segmentInset = 8
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: font], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: font], for: .selected)
        segmentedControl.addShadow(radius: 10, offset: CGSize(width: 0, height: -10))
    }
    
    private func setupSelectionView() {
        selectionView.titleLabel.text = "Select Images"
        selectionView.leftButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        selectionView.rightButton.setImage(UIImage(systemName: "trash"), for: .normal)
        selectionView.onLeftTapped = {
            let activityViewController = UIActivityViewController(activityItems: self.viewModel.selectedImages, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.selectionView
            self.present(activityViewController, animated: true)
        }
        selectionView.onRightTapped = {
            let imageWord = "Image\(self.viewModel.selectedImages.count > 1 ? "s" : "")"
            self.presentAlertWithOptions(title: "Delete \(imageWord)",
                                         message: "Are you sure you want to delete \(self.viewModel.selectedImages.count) \(imageWord)?",
                                         rightActionTitle: "Ok") {
                self.viewModel.deleteSelected()
                self.updateUI()
            }
        }
    }
    
    private func leftTapped() {
        if inSelectionMode {
            viewModel.selectAll(!viewModel.isAllSelected)
        } else {
            viewModel.isSortAscending.toggle()
        }
        updateUI()
    }

    private func rightTapped() {
        inSelectionMode.toggle()
        updateUI()
    }
    
    private func updateUI() {
        if viewModel.colorizedImagesCount == .zero {
            inSelectionMode = false
            navigationView.leftButton.isEnabled = false
            navigationView.rightButton.isEnabled = false
        } else {
            navigationView.leftButton.isEnabled = true
            navigationView.rightButton.isEnabled = true
        }
        if inSelectionMode {
            if viewModel.isAllSelected {
                navigationView.leftButton.setImage(UIImage(named: "DeselectAll"), for: .normal)
            } else {
                navigationView.leftButton.setImage(UIImage(named: "SelectAll"), for: .normal)
            }
            navigationView.rightButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            selectionView.isHidden = false
            if viewModel.selectedImages.isEmpty {
                selectionView.titleLabel.text = "Select Images"
            } else {
                let imageWord = "Image\(viewModel.selectedImages.count > 1 ? "s" : "")"
                selectionView.titleLabel.text = "\(viewModel.selectedImages.count) \(imageWord)"
            }
            
            
        } else {
            if viewModel.isSortAscending {
                navigationView.leftButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            } else {
                navigationView.leftButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            }
            navigationView.rightButton.setImage(UIImage(named: "Checkmark"), for: .normal)
            selectionView.isHidden = true
            viewModel.selectAll(false)
        }
        collectionView.reloadData()
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if inSelectionMode {
            viewModel.select(at: indexPath.row)
            updateUI()
        } else {
            onPreview?(viewModel.getIndexWithoutSort(indexPath.row))
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.colorizedImagesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setImage(viewModel.getImage(at: indexPath.row))
        cell.setColors(viewModel.getColors(at: indexPath.row))
        cell.setSelected(viewModel.isSelected(at: indexPath.row))
        return cell
    }
}
