//
//  ImageScrollView.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 27.11.21.
//

import UIKit

final class ImageScrollView: UIScrollView {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
        imageView.sizeToFit()
        contentSize = image.size
        setMinAndMaxZoomScale()
        zoomScale = minimumZoomScale
    }

    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(setMinAndMaxZoomScale), name: UIDevice.orientationDidChangeNotification, object: nil)
        addSubview(imageView)
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = true
        bouncesZoom = true
        contentInsetAdjustmentBehavior = .never
        decelerationRate = .normal
    }

    private func centerImage() {
        var newFrame = imageView.frame
        newFrame.origin.x = newFrame.size.width < bounds.size.width ? (bounds.size.width - newFrame.size.width) / 2 : 0
        newFrame.origin.y = newFrame.size.height < bounds.size.height ? (bounds.size.height - newFrame.size.height) / 2 : 0
        imageView.frame = newFrame
    }

    @objc private func setMinAndMaxZoomScale() {
        let shoudSetToMinZoomScale = zoomScale == minimumZoomScale
        minimumZoomScale = min(bounds.size.width / imageView.bounds.size.width, bounds.size.height / imageView.bounds.size.height)
        maximumZoomScale = minimumZoomScale * 4
        if shoudSetToMinZoomScale || zoomScale < minimumZoomScale {
            zoomScale = minimumZoomScale
        } else if zoomScale > maximumZoomScale {
            zoomScale = maximumZoomScale
        }
    }

    @objc private func didDoubleTapped(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        let finalScale = minimumZoomScale * (zoomScale == minimumZoomScale ? 4 : 1)
        var zoomRect = CGRect.zero
        zoomRect.size.width = bounds.size.width / finalScale
        zoomRect.size.height = bounds.size.height / finalScale
        zoomRect.origin.x = location.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = location.y - (zoomRect.size.height / 2)
        zoom(to: zoomRect, animated: true)
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
