//
//  GridView.swift
//  Weather
//
//  Created by Joshua Hernandez
//
//  UI of Grid View
//  Every City Added contains:
//  Current Temperature of location
//  High and Low for the day
//  Current Time
//  Dynamic BackGround of if currently Day or Night

import SwiftUI

struct GridView: View {
    @State private var searchInput: String = ""
    @State private var searchResults: [AutoCompleteRespone] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var currentWeather: [Int:WeatherResponse] = [:]
    @State private var searchTask: Task<Void, Never>?

    
    @Binding var savedCities: [AutoCompleteRespone]
    var onSelectCity: (AutoCompleteRespone) -> Void
    let weatherService: WeatherService
    
    var body: some View {
        NavigationStack {
            ZStack {
                GridBackGround()
                VStack {
                    Text("Weather")
                        .foregroundStyle(Color.white)
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: maxMainVStackWidth/20))
                    
                    SearchBar(searchInput: $searchInput)
                        .onChange(of: searchInput) { oldValue, newValue in
                            searchTask?.cancel()
                            searchTask = Task {
                                await searchForCity(query: newValue)
                            }
                        }
                    if isLoading {
                        ProgressView("Loading Cities")
                            .padding()
                    } else if !searchResults.isEmpty {
                        List(searchResults, id: \.id) { city in
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(city.region), \(city.country)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSelectCity(city)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: 300)
                        .background(Color.clear)
                    } else if searchResults.isEmpty && !searchInput.isEmpty {
                        Text("Search Result Not Found")
                            .foregroundStyle(Color.white)
                    }else if let error = errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    if !savedCities.isEmpty && searchInput.isEmpty {
                        List {
                            ForEach(savedCities, id: \.id) { city in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(city.name), \(city.country == "United States of America" ? city.region : city.country)")
                                            .foregroundStyle(.white)
                                            .font(.system(size: maxMainVStackWidth / 16))
                                        
                                        Text(currentTime(
                                            timeEpoch: Int(Date().timeIntervalSince1970),
                                            timezone: currentWeather[city.id]?.location.tzId ?? "")
                                        )
                                        .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        Text(currentWeather[city.id]?.current.condition.text ?? "N/A")
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        if let tempF = currentWeather[city.id]?.current.tempF {
                                            Text("\(Int(tempF))°")
                                                .foregroundStyle(.white)
                                                .font(.system(size: maxMainVStackWidth / 10))
                                        } else {
                                            Text("N/A")
                                                .foregroundStyle(.white)
                                                .font(.system(size: maxMainVStackWidth / 10))
                                        }

                                        Spacer()

                                        if let forecast = currentWeather[city.id]?.forecast.forecastday.first {
                                            let low = Int(forecast.day.mintempF)
                                            let high = Int(forecast.day.maxtempF)
                                            Text("L:\(low)° H:\(high)°")
                                                .foregroundStyle(.white)
                                                .font(.system(size: maxMainVStackWidth / 26))
                                        } else {
                                            Text("L:N/A H:N/A")
                                                .foregroundStyle(.white)
                                                .font(.system(size: maxMainVStackWidth / 26))
                                        }
                                    }
                                }
                                .padding()
                                .frame(height: maxMainVStackWidth / 3.5)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: currentWeather[city.id]?.current.isDay == 1 ? [Color("Day"), .blue] : [Color("Night"), .gray]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(28)
                                .onTapGesture {
                                    onSelectCity(city)
                                }
                                .task {
                                    await loadTempForCity(city)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        if let index = savedCities.firstIndex(where: { $0.id == city.id }) {
                                            savedCities.remove(at: index)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color("GridBackGroundColor").opacity(0.5))
                    }
                    Spacer()
                }
                .padding(.all, 20)
            }
        }
    }
    
    // Load current temperature for a city using cached weather service
    func loadTempForCity(_ city: AutoCompleteRespone) async {
        // Use lat,lon as parameter for api call, seems to be most accurate
        let locationKey = "\(city.lat),\(city.lon)"

        if let weather: WeatherResponse = await weatherService.fetchWeather(for: locationKey) {
            await MainActor.run {
                currentWeather[city.id] = weather
            }
        }
    }
    
    func searchForCity(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let service = AutoCompleteService()
        
        if let result: [AutoCompleteRespone] = await service.fetchSearch(for: query) {
            searchResults = result
        } else {
            errorMessage = "Failed to fetch search data"
        }
        
        isLoading = false
    }
}
