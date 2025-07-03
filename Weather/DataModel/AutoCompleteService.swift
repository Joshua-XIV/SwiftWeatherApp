//
//  AutoCompleteService.swift
//  Weather
//
//  Created by Joshua Hernandez
//

import Foundation

class AutoCompleteService{
    private let apiKey = getWeatherAPIKey()
    private let baseURL = "https://api.weatherapi.com/v1/search.json"
    
    func fetchSearch<T: Codable>(for location: String) async -> T? {
        var components = URLComponents(string: baseURL)!
        components.queryItems = 
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: location)
        ]
        
        guard let url = components.url else {
            return nil
        }
        
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, 
                    (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response Code \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return nil
            }
            
            let decoder = JSONDecoder()
            let searchData = try decoder.decode(T.self, from: data)
            
            return searchData
            
        } catch {
            print("Fetch search failed \(error)")
            return nil
        }
    }
}
