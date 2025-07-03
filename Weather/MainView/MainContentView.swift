//
//  MainContentView.swift
//  Weather
//
//  Created by Joshua Hernandez
//
//  UI of selected City
//  currently includes:
//  Hourly Forecast from current hour to next 24 hours
//  10 Day - Forecast with Low and High Temps for the Day

import SwiftUI
import CoreLocation


var totalDays = 10
var maxMainVStackWidth = UIScreen.main.bounds.width/1.2


struct MainContentView: View {
    let locationQuery: String?
    let city: AutoCompleteRespone
    let onAddCity: (AutoCompleteRespone) -> Void
    let isSaved: Bool
    let onBack: () -> Void
    @State private var weather: WeatherResponse?
    @State private var searchResult: AutoCompleteRespone?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchErrorMessage: String?
    //@StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading weather...")
            } else if let weather = weather {
                Backgound(isDay: isDay(weather: weather))
                
                VStack {
                    HStack {
                        Button("Exit") {
                            onBack()
                        }
                        .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        if !isSaved {
                            Button("Add") {
                                onAddCity(city)
                            }
                            .foregroundStyle(Color.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 40) // Adjust for status bar
                    
                    Spacer() // Push everything else down
                }.ignoresSafeArea()
                
                ScrollView(showsIndicators: false){
                    VStack {
                        CityName(city: weather.location.name, region: weather.location.country == "United States of America" ? weather.location.region : weather.location.country)
                        VStack(spacing: 0) {
                            TemperatureWithImage(
                                temperatute: weather.current.tempF,
                                isDay: isDay(weather: weather)).padding(.bottom, 8)
                            DisplayHourly(
                                isDay: isDay(weather: weather),
                                forecastDays: weather.forecast.forecastday,
                                currentWeather: weather.current.tempF,
                                timezone: weather.location.tzId)
                            DisplayDays(
                                isDay: isDay(weather: weather),
                                forecastDays: weather.forecast.forecastday,
                                timezoneID: weather.location.tzId).padding(.top)
                            VStack{
                                HStack{
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: String(weather.current.uv),
                                        text: "UV INDEX")
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: "\(String(weather.current.windMph))mph \(String(weather.current.windDir))",
                                        text: "WIND")
                                }
                                HStack{
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: "\(String(weather.current.humidity))%",
                                        text: "HUMIDITY")
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: String(weather.current.precipIn),
                                        text: "PRECIPTIATION")
                                }
                                HStack{
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: isDay(weather: weather) ? String(weather.forecast.forecastday[0].astro.sunset) : String(weather.forecast.forecastday[0].astro.sunrise),
                                        text: isDay(weather: weather) ? "SUNSET" : "SUNRISE")
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: "\(String(weather.current.pressureIn)) inHG",
                                        text: "PRESSURE")
                                }
                                HStack{
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: "\(String(weather.current.feelslikeF))°",
                                        text: "FEELS LIKE")
                                    DisplayInfo(
                                        isDay: isDay(weather: weather),
                                        weatherInfo: "\(String(weather.current.visMiles)) mi",
                                        text: "VISIBILITY")
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                }
            } else if let errorMessage = errorMessage {
                VStack {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                    Button("Retry") {
                        Task { await loadWeather() }
                    }
                }
            } else {
                // Default fallback in case nothing matches
                EmptyView()
            }
        }
        .task {
            // Automatically called when the view appears
            await loadWeather()
        }
    }
    
    func loadWeather() async {
        isLoading = true
        errorMessage = nil
        let service = WeatherService()
        
        // Attempt to fetch weather data using lat, lon of selected city
        if let fetchedWeather: WeatherResponse = await service.fetchWeather(for: locationQuery ?? "") {
            weather = fetchedWeather
        } else {
            errorMessage = "Failed to fetch weather data"
        }
        isLoading = false
    }
}
