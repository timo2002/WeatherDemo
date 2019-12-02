//
//  WeatherCommAPI.swift
//  WeatherDemo
//
//  Simple API for fetching MetaWeather JSON objects.
//
//  Created by Timo Erkkilä on 30.11.2019.
//  Copyright © 2019 Timo Erkkilä. All rights reserved.
//

import Foundation
import RxSwift

class WeatherCommAPI {
    
    static let HelsinkiMetaWeatherURL = URL(string: "https://www.metaweather.com/api/location/565346/")!

    static let LondonMetaWeatherURL = URL(string: "https://www.metaweather.com/api/location/44418/")!

    enum WeatherCommAPIError: Error {
        case noData
    }

    /// Downloads a weather JSON object from the specified MetaWeather URL.
    /// - Parameter url: The MetaWeather URL address
    class func getWeatherData<T: Codable>(url: URL) -> Single<T> {
        
        return Single<T>.create { single in
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    single(.error(error))
                    return
                }
                
                guard let data = data else {
                    print("No data")
                    single(.error(WeatherCommAPIError.noData))
                    return
                }
 
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    // MetaWeather curiously has super accurate time stamps:
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let weatherData = try decoder.decode(T.self, from: data)
                    
                    print("Fetched WeatherForecast JSON successfully from \(url)")

                    single(.success(weatherData))

                } catch let error {
                    print(error)
                    single(.error(error))
                }
            }
            
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
