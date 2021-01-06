//
//  Cache.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/16.
//

import UIKit

public protocol SBImageCacheType {
    typealias CacheResult = Result<UIImage, Error>
    
    var directory: String { get }
    
    var keepingDays: Double { get }
    
    func getImage(for url: URL) -> UIImage?

    func store(_ image: UIImage?, url: URL)
}
