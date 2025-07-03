//
//  WeatherService.swift
//  Weather
//
//  Created by Joshua Hernandez
//
//  WeatherService used to call weatherAPI
//  Caches city's data for 30 mins to prevent repeated API calls

import Foundation

class WeatherService {
    private let apiKey = getWeatherAPIKey()
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"
    
    private var cachedWeatherData: [String: (weather: WeatherResponse, timestamp: Date)] = [:]
    private var lastFetchDate: Date?
    private let cacheDuration: TimeInterval = 3600 // cache for 30 minutes
    
    func fetchWeather<T: Codable>(for location: String, days: Int = totalDays) async -> T? {
        // Check if we already have fresh cached data for this location
        if let cache = cachedWeatherData[location],
           Date().timeIntervalSince(cache.timestamp) < cacheDuration,
           let cached = cache.weather as? T {
            print("Returning cached weather data for \(location)")
            return cached
        }
        
        // Build URL for the forecasted days
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: location),
            URLQueryItem(name: "days", value: String(days)),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no")
        ]
        
        guard let url = components.url else {
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return nil
            }

            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(T.self, from: data)

            if let weatherResponse = weatherData as? WeatherResponse {
                cachedWeatherData[location] = (weather: weatherResponse, timestamp: Date())
            }

            return weatherData
        } catch {
            print("Fetch weather failed: \(error)")
            return nil
        }
    }
}
