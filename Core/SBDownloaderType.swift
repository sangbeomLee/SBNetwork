//
//  SBImageDownloaderType.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/17.
//

import Foundation

public protocol SBImageDownloaderType {
    typealias DownloadImageResult = Result<UIImage, Error>
    var session: URLSession { get }
    
    // downloadFunc
    func downloadImage(url: URL, completion:@escaping (DownloadImageResult) -> ())
}

public protocol SBDataDownloaderType {
    typealias DownloadDataResult = Result<Data, Error>
    var session: URLSession { get }
    
    func downloadJson(url: URL, completion:@escaping (DownloadDataResult) -> ())
}
