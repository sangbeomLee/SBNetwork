//
//  SBJsonManager.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/19.
//

import Foundation

enum SBJsonError: Error {
    case downloadError
    case decodeError
    case parseError
}

public class SBJsonManager {
    public static let shared = SBJsonManager(
        downloader: SBDownloader(session: URLSession.shared)
    )
    
    public var downloader: SBDownloader
    
    init(downloader: SBDownloader) {
        self.downloader = downloader
    }
}

extension SBJsonManager: SBJsonType {
    public func fetch<T, M>(_ url: URL, parseJSON:@escaping  ((T) -> M?), completion: @escaping (FetchResult<M>?) -> ()) where T : Decodable, M : SBModel {
        self.downloader.downloadJson(url: url) { result in
            switch result {
            case .success(let data):
                guard let decodedData:T = self.decodeJSON(with: data) else {
                    completion(.failure(SBJsonError.decodeError))
                    return
                }
                guard let parsedData = parseJSON(decodedData) else {
                    completion(.failure(SBJsonError.parseError))
                    return
                }
                completion(.success(parsedData))
            case .failure(_):
                completion(.failure(SBJsonError.downloadError))
            }
        }
    }
    
    public func decodeJSON<T>(with data: Data) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}

