//
//  SBImageType.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import Foundation

public protocol SBImageType {
    typealias FetchResult = Result<UIImage, Error>
    
    var downloader: URLSession { get }
    
    func fetch(_ url: URL, completion:@escaping (FetchResult) -> ())
}
