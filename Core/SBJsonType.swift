//
//  SBJsonType.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/19.
//

import Foundation

public protocol SBJsonType {
    typealias FetchResult<M> = Result<M, Error>
    
    
    var downloader: SBDownloader { get }
    
    func fetch<T:Decodable, M>(_ url: URL, parseJSON:@escaping (T) -> M?, completion:@escaping (FetchResult<M>) -> ())
    func decodeJSON<T: Decodable>(with data: Data) -> T?
}
