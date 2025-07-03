//
//  APIKeyManager.swift
//  Weather
//
//  Created by Joshua Hernandez on 7/3/25.
//

import Foundation
import Combine

class ApiKeyManager: ObservableObject {
    @Published var weatherService = WeatherService()
    @Published var hasApiKey = false
    
    func loadApiKey() {
        fetchWeatherApiKey { [weak self] key in
            DispatchQueue.main.async {
                if let key = key {
                    self?.weatherService.setApiKey(key)
                    self?.hasApiKey = true  // notify UI key is ready
                } else {
                    print("Failed to fetch API key")
                    self?.hasApiKey = false
                }
            }
        }
    }
}
