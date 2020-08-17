//
//  SBImageDownloaderType.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/17.
//

import Foundation

public protocol SBImageDownloaderType {
    typealias DownloadResult = Result<UIImage, Error>
    var session: URLSession { get }
    
    // downloadFunc
    func downloadImage(url: URL, completion:@escaping (DownloadResult) -> ())
}
