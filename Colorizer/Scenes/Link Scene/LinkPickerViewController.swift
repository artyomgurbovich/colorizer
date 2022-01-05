//
//  LinkPickerViewController.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 13.11.21.
//

import UIKit

final class LinkPickerViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomLayoutConstraint: NSLayoutConstraint!
    
    weak var delegate: LinkPickerDelegate?
    private let notificationCenter = NotificationCenter.default
    private let pasteboard = UIPasteboard.general
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        setupUI()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyBoardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        textViewBottomLayoutConstraint.constant = keyBoardSize.height
    }
    
    private func setupUI() {
        setupNavigationView()
        setupTextView()
    }
    
    private func setupNavigationView() {
        navigationView.titleLabel.text = "Link"
        navigationView.leftButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        navigationView.rightButton.setImage(UIImage(systemName: "square.on.square"), for: .normal)
        navigationView.onLeftTapped = {
            self.dismiss(animated: true)
        }
        navigationView.onRightTapped = {
            self.textView.text = self.pasteboard.string
        }
    }
    
    private func setupTextView() {
        textView.textContainerInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        textView.layer.cornerRadius = 25
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor(named: "White")?.cgColor
        textView.delegate = self
    }
}

extension LinkPickerViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            guard let link = textView.text else { return false }
            delegate?.linkPicker(self, didPickLink: link)
            return false
        }
        return true
    }
}
