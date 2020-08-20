//
//  WeatherData.swift
//  Clima
//
//  Created by 이상범 on 2020/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

public struct Main: Decodable {
    let temp: Double
}
public struct Weather: Decodable {
    let main: String
    let description: String
    let id: Int
}

public struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}
