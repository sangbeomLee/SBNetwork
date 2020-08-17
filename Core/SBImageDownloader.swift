//
//  SBImageDownloader.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/17.
//

import UIKit

enum DownloaderError: Error {
    case dataError
    case responseError
    case fetchError
}

public class SBImageDownloader {
    public let session: URLSession
    
    init (session: URLSession) {
        self.session = session
    }
}

extension SBImageDownloader: SBImageDownloaderType {
    public func downloadImage(url: URL, completion: @escaping (DownloadResult) -> ()) {
        self.session.dataTask(with: url) { (data, response, error) in
            guard error == nil else{
                completion(DownloadResult.failure(DownloaderError.fetchError))
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completion(DownloadResult.failure(DownloaderError.responseError))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(DownloadResult.failure(DownloaderError.dataError))
                return
            }
            DispatchQueue.main.async {
                completion(DownloadResult.success(image))
            }
        }.resume()
    }
    
    
}
