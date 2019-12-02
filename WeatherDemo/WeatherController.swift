//
//  WeatherController.swift
//  WeatherDemo
//
//  Created by Timo Erkkilä on 1.12.2019.
//  Copyright © 2019 Timo Erkkilä. All rights reserved.
//

import Foundation
import RxSwift

class WeatherController {

    static let shared = WeatherController()

    private init() {}
    
    func createWeatherDataStream(source: URL, interval: DispatchTimeInterval) -> Observable<WeatherData> {
        return Observable.create { observer in
            print("Subscribed")
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now(), repeating: interval)
            let disposeBag = DisposeBag()

            let observable = Disposables.create {
                print("Disposed")
                timer.cancel()
            }

            timer.setEventHandler {
                if observable.isDisposed {
                    return
                }
                
                let single: Single<WeatherForecast> = WeatherCommAPI.getWeatherData(url: source)
                single.subscribe { event in
                    switch event {
                        case .success(let weather):
                            let weatherData = weather.consolidated_weather[0]
                            print("JSON: ", weatherData)
                            observer.on(.next(weatherData))
                        case .error(let error):
                            print("Error: ", error)
                    }
                }.disposed(by: disposeBag)
            
            }
            timer.resume()

            return observable
        }
    }

}
