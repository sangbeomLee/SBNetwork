//
//  UIImageView+Extension.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import UIKit

extension UIImageView {
    public func getImage(url: URL) {
        SBImageManager.shared.fetch(url) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error):
                print("UIImageView_getImage_error : \(error)")
            }
        }
        // indicator 해보자.
    }
}
