//
//  WeatherViewModel.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 12/03/23.
//

import WeatherKit
import CoreLocation

struct MyCurrentWeather {
    let temperature: Double
    let condition: String
}

struct MyDayWeather {
    let higherTemperature: Double
    let lowerTemperature: Double
    let rainfall: Double
}


@available(iOS 16.0, *)
public class WeatherViewModel: ObservableObject {
    static let shared = WeatherViewModel()
    
    let service = WeatherService()
    var currentWeather: CurrentWeather?
    @Published var dayWeather: [DayWeather] = []
    
    func getCurrentWeather(_ location: String) async {
        do {
            let forecast = try await self.service.weather(for: locationManager(location))
            currentWeather = forecast.currentWeather
        } catch {
            assertionFailure(error.localizedDescription)
            print("ERRO")
        }
    }
    
    func getDayWeather(_ location: String) async {
        do {
            let forecast = try await self.service.weather(for: locationManager(location))
            dayWeather = forecast.dailyForecast.forecast
        } catch {
            assertionFailure(error.localizedDescription)
            print("ERRO")
        }
    }
    
    func locationManager(_ location: String) -> CLLocation {
        let coordsSeparated = location.split(separator: " ")
        if let latitude = CLLocationDegrees(coordsSeparated[0]), let longitude = CLLocationDegrees(coordsSeparated[1]) {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        return CLLocation(latitude: 0, longitude: 0)
    }
}
