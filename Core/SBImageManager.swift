//
//  SBImageManager.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/14.
//

import Foundation

enum SBImageError: Error {
    case downloadError
}

public class SBImageManager {
    public static let shared = SBImageManager(
        downloader: SBDownloader(session: URLSession.shared),
        cache: SBImageCache(fileManager: FileManager.default, minimumDay: 7.0)
    )
    
    public var downloader: SBDownloader
    public var cache: SBImageCache
    
    init(downloader: SBDownloader, cache: SBImageCache) {
        self.downloader = downloader
        self.cache = cache
    }
    
    public func checkCacheImage(url: URL) -> UIImage? {
        var image: UIImage?
        // getImage from memory
        cache.getImage(for: url, location: .memory) { (result) in
            switch result {
            case .success(let resultImage):
                image = resultImage
            case .failure(let error): // 메모리에 없다. -> 디스크 체크 -> 디스크에 없다. -> 다운로드
                print(error)
                self.cache.getImage(for: url, location: .disk) { (result) in
                    switch result {
                    case .success(let resultImage):
                        image = resultImage
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        return image
    }
}

extension SBImageManager: SBImageType {
    public func fetch(_ url: URL, completion:@escaping (FetchResult) -> ()) {
        // 캐시에 이미지가 있으면 그대로 반환
        if let image = checkCacheImage(url: url) {
            completion(FetchResult.success(image))
        } else {
            // 네트워크 통신 다운로드
            self.downloader.downloadImage(url: url) { result in
                switch result {
                case .success(let image):
                    // 다운로드가 다 되면 메모리, 디스크에 저장한다.
                    self.cache.storeImage(image, for: url, location: .memory)
                    self.cache.storeImage(image, for: url, location: .disk)
                    completion(FetchResult.success(image))
                case .failure(_):
                    completion(FetchResult.failure(SBImageError.downloadError))
                }
            }
        }
    }
}
