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

public class SBDownloader {
    public let session: URLSession
    
    init (session: URLSession) {
        self.session = session
    }
}

extension SBDownloader: SBImageDownloaderType {
    public func downloadImage(url: URL, completion: @escaping (DownloadImageResult) -> ()) {
        self.session.dataTask(with: url) { (data, response, error) in
            guard error == nil else{
                completion(DownloadImageResult.failure(DownloaderError.fetchError))
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completion(DownloadImageResult.failure(DownloaderError.responseError))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(DownloadImageResult.failure(DownloaderError.dataError))
                return
            }
            DispatchQueue.main.async {
                completion(DownloadImageResult.success(image))
            }
        }.resume()
    }
}

extension SBDownloader: SBDataDownloaderType {
    public func downloadJson(url: URL, completion: @escaping (DownloadDataResult) -> ()) {
        self.session.dataTask(with: url) { (data, response, error) in
            guard error == nil else{
                completion(DownloadDataResult.failure(DownloaderError.fetchError))
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completion(DownloadDataResult.failure(DownloaderError.responseError))
                return
            }
            guard let data = data else {
                completion(DownloadDataResult.failure(DownloaderError.dataError))
                return
            }
            completion(DownloadDataResult.success(data))
        }.resume()
    }
    
    
}
