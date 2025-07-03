//
//  Secrets.swift
//  Weather
//
//
//

import Foundation

func getWeatherAPIKey() -> String {
    guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: path),
          let apiKey = plist["WEATHER_API_KEY"] as? String else {
        fatalError("API Key not found. Make sure Secrets.plist exists and is configured correctly.")
    }
    return apiKey
}
