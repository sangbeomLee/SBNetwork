//
//  SBImageManager.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import Foundation

private enum SBImageError: Error {
    case downloadError
    case downloadedDataError
}

public class SBImageManager: SBImageType {
    public static let shared = SBImageManager(
        downloader: SBDownloader(session: URLSession.shared),
        cache: SBImageCache(fileManager: FileManager.default)
    )
    
    public var downloader: SBDownloader
    public var cache: SBImageCache
    
    init(downloader: SBDownloader, cache: SBImageCache) {
        self.downloader = downloader
        self.cache = cache
    }
    
    public func fetch(_ url: URL, completion: @escaping (FetchResult) -> ()) {
        // 캐시에 이미지가 있으면 그대로 반환
        if let image = cache.getImage(for: url) {
            completion(FetchResult.success(image))
        } else {
            downloader.downloadData(from: url) {[weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        completion(FetchResult.failure(SBImageError.downloadedDataError))
                        return
                    }
                    
                    self?.cache.store(image, url: url)
                    completion(FetchResult.success(image))
                case .failure(_):
                    completion(FetchResult.failure(SBImageError.downloadError))
                }
            }
        }
    }
}
