//
//  Cache.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/16.
//

import UIKit

// 캐시 위치
public enum CacheLocation {
    // 메모리
    case memory
    // 디스크
    case disk
}

public protocol SBImageCacheType {
    typealias CacheResult = Result<UIImage, Error>
    var directory: String { get }
    var minimumDay: Double { get }
    
    // 캐시에 저장된 이미지 가져온다.
    func getImage(for url: URL, location: CacheLocation, completion: ((CacheResult) -> Void)?)

    // 캐시 저장
    func storeImage(_ image: UIImage?, for url: URL, location: CacheLocation)
    
}
