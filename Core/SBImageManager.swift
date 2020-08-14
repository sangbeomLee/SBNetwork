//
//  SBImageManager.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import Foundation

enum SBImageError: Error {
    case dataError
    case responseError
    case fetchError
}

public class SBImageManager: SBImageType {
    public static let shared = SBImageManager(downloader: URLSession.shared)
    
    public var downloader: URLSession
    
    init(downloader: URLSession) {
        self.downloader = downloader
    }
}

extension SBImageManager {
    public func fetch(_ url: URL, completion:@escaping (FetchResult) -> ()) {
        self.downloader.dataTask(with: url) { (data, response, error) in
            guard error == nil else{
                completion(FetchResult.failure(SBImageError.fetchError))
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completion(FetchResult.failure(SBImageError.responseError))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(FetchResult.failure(SBImageError.dataError))
                return
            }
            DispatchQueue.main.async {
                completion(FetchResult.success(image))
            }
        }.resume()
    }
}
