//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Joshua Hernandez
//  !!!CURRENTLY NOT IN USE!!!
//  Ideally use this model to call api, helps structure/organization
//  Has deprecate locationManager, need to refactor 

/*
import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var searchResult: AutoCompleteRespone?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchErrorMessage: String?
    
    let locationManager = LocationManager()

    func loadWeather() async {
        isLoading = true
        errorMessage = nil
        let service = WeatherService()

        if let location = locationManager.location {
            if let fetchedWeather: WeatherResponse = await service.fetchWeather(for: "\(location.latitude),\(location.longitude)") {
                self.weather = fetchedWeather
            } else {
                self.errorMessage = "Failed to fetch weather data"
            }
        }
        isLoading = false
    }
    
    func loadWeathers(for coords: String) async {
        isLoading = true
        errorMessage = nil
        let service = WeatherService()

        if let fetchedWeather: WeatherResponse = await service.fetchWeather(for: coords) {
            DispatchQueue.main.async {
                self.weather = fetchedWeather
                self.isLoading = false
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch weather data"
                self.isLoading = false
            }
        }
    }

    func fetchCities(for location: String) async {
        searchErrorMessage = nil
        let service = AutoCompleteService()

        if let fetchedSearch: AutoCompleteRespone = await service.fetchSearch(for: location) {
            searchResult = fetchedSearch
        } else {
            searchErrorMessage = "Failed to fetch search data"
        }
    }

    func isDay() -> Bool {
        return weather?.current.isDay == 1
    }
}
*/
