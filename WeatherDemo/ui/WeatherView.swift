//
//  WeatherView.swift
//  WeatherDemo
//
//  Created by Timo Erkkilä on 1.12.2019.
//  Copyright © 2019 Timo Erkkilä. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa

struct WeatherView: View {
    
    class WeatherInfo: ObservableObject {
        @Published var temperature = ""
        @Published var updated = ""
    }
    
    let cityHelsinki = "Helsinki"
    let cityLondon = "London"
    
    @State private var currentCity = ""
    @ObservedObject private var weatherInfo = WeatherInfo()
    @State private var weatherDataStream: Disposable?
    @State private var weatherDataBinder = Binder<WeatherData>(WeatherInfo()) {
        info, data in
    }
    
    private let disposeBag = DisposeBag()
    
    struct CustomButtonStyle: ButtonStyle {
        var color: Color = .red
        
        public func makeBody(configuration: CustomButtonStyle.Configuration) -> some View {
            configuration.label
                .font(.system(size: 25))
                .foregroundColor(.white)
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 5).fill(color))
                .compositingGroup()
                .shadow(color: .black, radius: 3)
                .opacity(configuration.isPressed ? 0.5 : 1.0)
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text(currentCity)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                Text("Temperature: \(weatherInfo.temperature)")
                    .font(.system(size: 20))
                Text("Updated: \(weatherInfo.updated)")
                    .font(.system(size: 20))
            }
            .frame(height: 400)
            .onAppear {
                self.weatherDataBinder = Binder<WeatherData>(self.weatherInfo) {
                    info, weatherData in
                    
                    info.temperature = WeatherView.getTempString(weatherData: weatherData)
                    info.updated = WeatherView.getTimeString(date: Date())
                }
                self.currentCity = self.cityLondon
                self.startWeatherDataStream(cityURL: WeatherCommAPI.LondonMetaWeatherURL)
            }
            HStack(spacing: 20) {
                Button(cityLondon) {
                    print("London tapped")
                    self.currentCity = self.cityLondon
                    self.startWeatherDataStream(cityURL:
                        WeatherCommAPI.LondonMetaWeatherURL)
                }
                .buttonStyle(CustomButtonStyle(color: .blue))
                
                Button(cityHelsinki) {
                    print("Helsinki tapped")
                    self.currentCity = self.cityHelsinki
                    self.startWeatherDataStream(cityURL: WeatherCommAPI.HelsinkiMetaWeatherURL)
                }
                .buttonStyle(CustomButtonStyle(color: .blue))
            }
        }
    }
    
    private func startWeatherDataStream(cityURL: URL) {
        
        weatherInfo.temperature = "fetching data..."
        weatherInfo.updated = "please, wait"
        
        // Dispose old stream:
        if let stream = weatherDataStream {
            stream.dispose()
            weatherDataStream = nil
        }
        
        // Create and bind the new stream:
        weatherDataStream = WeatherController.shared.createWeatherDataStream(
            source: cityURL, interval: .seconds(60))
            .bind(to: weatherDataBinder)

        // Make sure the stream is disposed when the view gets removed:
        weatherDataStream?.disposed(by: disposeBag)
    }
    
    private static func getTempString(weatherData: WeatherData) -> String {
        let temp = Int(round(weatherData.the_temp))
        return "\(temp)°C"
    }
    
    private static func getTimeString(date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = String(format: "%02d", calendar.component(.minute, from: date))
        return "\(hour):\(minutes)"
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
