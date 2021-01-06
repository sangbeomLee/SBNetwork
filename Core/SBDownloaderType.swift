//
//  SBImageDownloaderType.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/17.
//

import Foundation

public protocol SBDownloaderType {
    typealias DownloadedDataResult = Result<Data, Error>
    
    var session: URLSession { get }
    
    func downloadData(from url: URL, completion: @escaping (DownloadedDataResult) -> ())
}
