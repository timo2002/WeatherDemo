//
//  WeatherData.swift
//  WeatherDemo
//
//  Created by Timo Erkkilä on 1.12.2019.
//  Copyright © 2019 Timo Erkkilä. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    var id: Int
    var weather_state_name: String
    var weather_state_abbr: String
    var wind_direction_compass: String
    var created: Date
    var applicable_date: String
    var min_temp: Float
    var max_temp: Float
    var the_temp: Float
    var wind_speed: Float
    var wind_direction: Float
    var air_pressure: Float
    var humidity: Int
    var visibility: Float
    var predictability: Int
}
