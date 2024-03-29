# WeatherDemo
Simple demo to test SwiftUI basic usage and RxSwift for receiving temperature information from the MetaWeather service.

The application has a single UI view represented by the ui/WeatherView struct.
WeatherView initially subribes to RX observable (created in WeatherController) that publishes London's current weather information.
The required JSON weather forecast objects are fetched and parsed from the MetaWeather's service.

When either of WeatherView's buttons are pressed the existing RX observable is disposed and a new observable is created in order to reset the timer and the URL that specifies the source of the weather information (only two URLS - one for London, one for Helsinki).

Classes/Structs explained briefly:

* ui/WeatherView - the main view of the app.
* WeatherController - the main controller, only contains code for creating weather information observable.
                    This observable publishes the weather data objects periodically (once per minute).
* data/WeatherForecast - the struct for holding MetaWeather's forecast data.
* data/WeatherData - the struct for holding detailed weather data.
* comm/WeatherCommAPI - contains the networking code. Implements fetching and parsing of weather forecast JSON objects and
                      publishes them as Single observables.
* All other files were automatically generated by Xcode on creating the project.
                      
