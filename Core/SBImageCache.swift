//
//  SBImageCache.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/16.
//

import UIKit

// cacheError handle
enum CacheError: Error {
    case outOfComponents
    case outOfMemory
    case outOfDisk
    case pathError
}

public class SBImageCache{
    let fileManager: FileManager
    // 내부 캐시
    let cacheStorage = NSCache<NSString, UIImage>()
    //var componentsByName = Dictionary<String, String>()
    public let directory = "Images"
    
    init (fileManager: FileManager) {
        self.fileManager = fileManager
        // fileManager에 저장되어있는 이름을 옮겨야한다. componentsByName에
        // dicrectory가 만들어지지 않았다면 만든다.
        guard let diskPath = getDiskPath() else {
            fatalError("disk Path Error")
        }
        // 디렉토리가 없다면 만들어준다.
        if !fileManager.fileExists(atPath: diskPath.path) {
            try? fileManager.createDirectory(at: getDiskPath()!, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // disk path를 구하는 함수
    func getDiskPath() -> URL? {
        let diskPaths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let diskPath = diskPaths.first else {
            return nil
        }

        return diskPath.appendingPathComponent(directory)
    }
    
    // image path를 구하는 함수
    func getImagePath(url: URL) -> String? {
        guard let diskPath = getDiskPath() else {
            return nil
        }
        
        return diskPath.appendingPathComponent(url.lastPathComponent).path
    }
    
}

// url-key : name
// name : imageName

extension SBImageCache: SBImageCacheType {
    public func getImage(for url: URL, location: CacheLocation, completion: ((CacheResult) -> Void)?) {
        let imageName = url.lastPathComponent
       
        switch location {
        case .memory:
            // componentsByName에 있다 -> 메모리에 있다.
            if let image = cacheStorage.object(forKey: imageName as NSString) {
                print("find in memory")
                completion?(.success(image))
            } else {
                completion?(.failure(CacheError.outOfMemory))
            }
        case .disk:
            guard let imagePathStr = getImagePath(url: url) else {
                completion?(.failure(CacheError.pathError))
                return
            }
            if let image = UIImage(contentsOfFile: imagePathStr) {
                print("find in disk")
                // disk에서 찾았다 -> memory에 없으면 memory에 복사한다.
                storeImage(image, for: url, location: .memory)
                completion?(.success(image))
            } else {
                completion?(.failure(CacheError.outOfDisk))
            }
        }
    }
    
    public func storeImage(_ image: UIImage?, for url: URL, location: CacheLocation) {
        // url의 마지막 이름을 이미지 이름으로 저장하자.
        let imageName = url.lastPathComponent
        
        switch location {
        case .memory:
            if let safeImage = image {
                cacheStorage.setObject(safeImage, forKey: imageName as NSString)
            } else {
                cacheStorage.removeObject(forKey: imageName as NSString)
            }
        case .disk:
            guard let imagePathStr = getImagePath(url: url) else {
                return
            }
            if let safeImage = image, let data = safeImage.jpegData(compressionQuality: 0.8) {
                fileManager.createFile(atPath: imagePathStr, contents: data, attributes: nil)
            } else {
                try? fileManager.removeItem(atPath: imagePathStr)
            }
        }
        return
    }
}

