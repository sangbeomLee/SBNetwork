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
    case removeError
}

public class SBImageCache{
    let fileManager: FileManager
    // 내부 캐시
    let cacheStorage = NSCache<NSString, UIImage>()
    var currentDate = Date()
    //var componentsByName = Dictionary<String, String>()
    public let directory = Constant.CACHE_DIRACTORY
    // 기본 10일이다.
    public let minimumDay: Double
    
    init (fileManager: FileManager, minimumDay: Double = Constant.CACHE_MINIMUMDAY) {
        self.fileManager = fileManager
        self.minimumDay = minimumDay
        makeDirectory()
        cleanUp()
    }
    
    fileprivate func makeDirectory() {
        guard let diskPath = getDiskPath() else {
            fatalError("disk Path Error")
        }
        // 디렉토리가 없다면 만들어준다.
        if !fileManager.fileExists(atPath: diskPath.path) {
            try? fileManager.createDirectory(at: getDiskPath()!, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // disk path를 구하는 함수
    fileprivate func getDiskPath() -> URL? {
        let diskPaths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let diskPath = diskPaths.first else {
            return nil
        }

        return diskPath.appendingPathComponent(directory)
    }
    
    // image path를 구하는 함수
    fileprivate func getImagePath(url: URL) -> String? {
        guard let diskPath = getDiskPath() else {
            return nil
        }
        
        return diskPath.appendingPathComponent(url.lastPathComponent).path
    }
    
    fileprivate func cleanUp() {
        // 이전 날짜
        let minimumDate = Date().addingTimeInterval(-minimumDay*24*60*60)
        // diskPath를 찾는다.
        guard let diskPath = getDiskPath()?.path else {
            print(CacheError.pathError)
            return
        }

        do {
            // fileManager의 currentDirectory를 바꾼다. -> 캐시디렉토리로
            if fileManager.changeCurrentDirectoryPath(diskPath) {
                // 파일들을 하나씩 가져온다.
                for file in try fileManager.contentsOfDirectory(atPath: ".") {
                    // 저장 시간 정보를 가져온다.
                    if let creationDate = try fileManager.attributesOfItem(atPath: file)[FileAttributeKey.creationDate] as? Date {
                        // 만든날짜가 내가 정한 날짜보다 작으면 지운다.
                        if creationDate < minimumDate {
                            try fileManager.removeItem(atPath: file)
                            print("remove: \(file)")
                        }
                    }
                }
            }
        }
        catch {
            print(CacheError.removeError)
        }
    }
    private func isDayOver() -> Bool {
        let baseDate = Date().addingTimeInterval(-24*60*60)
        if currentDate < baseDate {
            currentDate = Date()
            return true
        } else {
            return false
        }
    }
}

// url-key : name
// name : imageName

extension SBImageCache: SBImageCacheType {
    public func getImage(for url: URL, location: CacheLocation, completion: ((CacheResult) -> Void)?) {
        if isDayOver() { cleanUp() }
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
        if isDayOver() { cleanUp() }
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
            // 일정 시간이 지나면 자동으로 지우게 해야한다.
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

