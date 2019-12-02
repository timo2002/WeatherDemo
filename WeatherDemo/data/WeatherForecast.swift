//
//  WeatherForecast.swift
//  WeatherDemo
//
//  Created by Timo Erkkilä on 1.12.2019.
//  Copyright © 2019 Timo Erkkilä. All rights reserved.
//

import Foundation

struct WeatherForecast: Codable {
    var consolidated_weather: [WeatherData]
    var time: String
    var title: String
}
