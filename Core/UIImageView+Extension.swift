//
//  UIImageView+Extension.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import UIKit

extension UIImageView {
    public func setImage(url: URL, indicator: Bool = false) {
        var indicatorView: SBIndicatorView?
        if indicator {
            indicatorView = SBIndicatorView(width: self.frame.width, height: self.frame.height)
            indicatorView?.startAnimating()
            self.addSubview(indicatorView!)
        }
        
        SBImageManager.shared.fetch(url) { (result) in
            switch result {
            case .success(let image):
                indicatorView?.stopAnimating()
                self.image = image
            case .failure(let error):
                indicatorView?.stopAnimating()
                print("UIImageView_getImage_error : \(error)")
            }
            indicatorView?.removeFromSuperview()
        }
        
    }
}
