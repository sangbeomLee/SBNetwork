//
//  UIImageView+Extension.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import UIKit

private enum Icon {
    static let LoadFailed = UIImage(named: "loadFailed")
}

extension UIImageView {
    public func setImage(from url: URL, showsIndicator: Bool = false) {
        var indicatorView: SBIndicatorView?
        
        if showsIndicator {
            let indicator = SBIndicatorView(width: frame.width, height: frame.height)
            indicator.startAnimating()
            addSubview(indicator)
            indicatorView = indicator
        }
        
        SBImageManager.shared.fetch(url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure(let error):
                    print("UIImageView_getImage_error : \(error)")
                    self?.image = Icon.LoadFailed
                }
                
                indicatorView?.stopAnimating()
                indicatorView?.removeFromSuperview()
            }
        }
    }
}
