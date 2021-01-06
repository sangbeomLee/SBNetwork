//
//  SBImageCache.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/16.
//

import UIKit

private enum Constant {
    static let cacheDiractory: String = "Images"
    static let cacheKeepingDays: Double = 0.0
    static let secondsOfDay: Double = 24*60*60
    static let compressionQuality: CGFloat = 0.8
}

// cacheError handle
private enum CacheError: Error {
    case outOfComponents
    case outOfMemory
    case outOfDisk
    case pathError
    case removeError
}

private enum CacheLocation {
    case memory
    case disk
}

public class SBImageCache: SBImageCacheType {
    private let fileManager: FileManager
    private let cacheStorage = NSCache<NSString, UIImage>()
    private var currentDate = Date()
    
    public let directory = Constant.cacheDiractory
    public let keepingDays: Double
    
    var diskPathURL: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(directory)
    }
    
    var isPassedDate: Bool {
        let baseDate = Date().addingTimeInterval(-24*60*60)
        if currentDate < baseDate {
            currentDate = Date()
            return true
        } else {
            return false
        }
    }
    
    init (fileManager: FileManager, keepingDays: Double = Constant.cacheKeepingDays) {
        self.fileManager = fileManager
        self.keepingDays = keepingDays
        setupDirectory()
        deleteOldImages()
    }
    
    public func getImage(for url: URL) -> UIImage?{
        if isPassedDate {
            deleteOldImages()
        }
        
        var image: UIImage?

        getImage(for: url, location: .memory) { result in
            switch result {
            case .success(let resultImage):
                image = resultImage
            case .failure(_): // 메모리에 없다. -> 디스크 체크 -> 디스크에 없다. -> 다운로드
                self.getImage(for: url, location: .disk) { (result) in
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
    
    private func getImage(for url: URL, location: CacheLocation, completion: ((CacheResult) -> Void)?) {
        let imageName = url.lastPathComponent
        
        switch location {
        case .memory:
            // componentsByName에 있다 -> 메모리에 있다.
            if let image = cacheStorage.object(forKey: imageName as NSString) {
                completion?(.success(image))
            } else {
                completion?(.failure(CacheError.outOfMemory))
            }
        case .disk:
            guard let imagePath = imagePath(from: url) else {
                completion?(.failure(CacheError.pathError))
                return
            }
            
            if let image = UIImage(contentsOfFile: imagePath) {
                // disk에서 찾았다 -> memory에 없으면 memory에 복사한다.
                store(image, url: url, location: .memory)
                completion?(.success(image))
            } else {
                completion?(.failure(CacheError.outOfDisk))
            }
        }
    }

    public func store(_ image: UIImage?, url: URL) {
        if isPassedDate {
            deleteOldImages()
        }
        
        store(image, url: url, location: .memory)
        store(image, url: url, location: .disk)
    }
    
    private func store(_ image: UIImage?, url: URL, location: CacheLocation) {
        let imageName = url.lastPathComponent
        
        switch location {
        case .memory:
            if let safeImage = image {
                cacheStorage.setObject(safeImage, forKey: imageName as NSString)
            } else {
                cacheStorage.removeObject(forKey: imageName as NSString)
            }
        case .disk:
            guard let imagePath = imagePath(from: url) else { return }
            
            if let safeImage = image, let data = safeImage.jpegData(compressionQuality: Constant.compressionQuality) {
                fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
            } else {
                try? fileManager.removeItem(atPath: imagePath)
            }
        }
    }
}

// MARK: - private

private extension SBImageCache {
    func setupDirectory() {
        guard let diskPath = diskPathURL else {
            fatalError("disk Path Error")
        }
        // 디렉토리가 없다면 만들어준다.
        if !fileManager.fileExists(atPath: diskPath.path) {
            try? fileManager.createDirectory(at: diskPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func imagePath(from url: URL) -> String? {
        diskPathURL?.appendingPathComponent(url.lastPathComponent).path
    }
    
    func deleteOldImages() {
        guard let diskPath = diskPathURL?.path else {
            print(CacheError.pathError)
            return
        }
        
        // TODO: 다시 확인 할 것
        let limitedDate = Date().addingTimeInterval(-keepingDays * Constant.secondsOfDay)
        
        do {
            // fileManager의 currentDirectory를 바꾼다. -> 캐시디렉토리로
            if fileManager.changeCurrentDirectoryPath(diskPath) {
                // 파일들을 하나씩 가져온다.
                try fileManager.contentsOfDirectory(atPath: ".").forEach { file in
                    // 저장 시간 정보를 가져온다.
                    if let creationDate = try fileManager.attributesOfItem(atPath: file)[FileAttributeKey.creationDate] as? Date {
                        // 만든날짜가 내가 정한 날짜보다 작으면 지운다.
                        if creationDate < limitedDate {
                            try fileManager.removeItem(atPath: file)
                            print("remove old image: \(file)")
                        }
                    }
                }
            }
        }
        catch {
            print(CacheError.removeError)
        }
    }
}
