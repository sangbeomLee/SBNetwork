//
//  Extension.swift
//  SBNetwork
//
//  Created by 이상범 on 2020/08/16.
//

import Foundation

extension Date {
    static func toUniqueName() -> String{
        let dateFormatter = DateFormatter()
        guard let uuid = UUID().uuidString.split(separator: "-").first else {
            return UUID().uuidString
        }
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: Date()) + "_" + uuid
    }
}
