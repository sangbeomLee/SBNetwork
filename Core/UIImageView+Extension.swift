//
//  UIImageView+Extension.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import UIKit

extension UIImageView {
    public func setImage(url: URL, indicator: Bool = false) {
        var activityIndicator: UIActivityIndicatorView?
        if indicator { activityIndicator = makeIndicatorView(isAnimating: true) }
        
        SBImageManager.shared.fetch(url) { (result) in
            switch result {
            case .success(let image):
                activityIndicator?.stopAnimating()
                self.image = image
            case .failure(let error):
                print("UIImageView_getImage_error : \(error)")
            }
        }
        // add indicator
        if let subView = activityIndicator {
            self.addSubview(subView)
        }
    }
    private func makeIndicatorView(isAnimating: Bool) -> UIActivityIndicatorView {
        // indicator 해보자.
        let activityIndicator = UIActivityIndicatorView()
        var size = self.frame.width/4
        if size < 50 {
            size = 50
        } else if size > 150 {
            size = 150
        }
        activityIndicator.frame = CGRect(x: 0, y: 0, width: size, height: size)
        activityIndicator.center = self.center
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .white
        if isAnimating {
            activityIndicator.startAnimating()
        }
        return activityIndicator
    }
}
