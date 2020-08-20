//
//  WeatherModel.swift
//  Clima
//
//  Created by 이상범 on 2020/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import SBNetwork

struct WeatherModel{
    static func parse(networkModel: WeatherData) -> WeatherModel? {

        let id = networkModel.weather[0].id
        let name = networkModel.name
        let temp = networkModel.main.temp

        let weather = WeatherModel(id: id, name: name, temp: temp)
        return weather
    }
    
    let id: Int
    let name: String
    let temp: Double
    
    var stringTemp: String {
        return String(format: "%.1f", temp)
    }
    
    var conditionName:String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
