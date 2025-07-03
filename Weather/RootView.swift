//
//  RootView.swift
//  Weather
//
//  Created by Joshua Hernandezustin
//  

import SwiftUI

struct RootView: View {
    @StateObject private var apiKeyManager = ApiKeyManager()
    @State private var showGrid = true
    @State private var savedCities: [AutoCompleteRespone] = []
    @State private var selectedCity: AutoCompleteRespone? = nil

    var body: some View {
        NavigationStack {
            if apiKeyManager.hasApiKey {
                if showGrid {
                    GridView(
                        savedCities: $savedCities,
                        onSelectCity: { city in
                            selectedCity = city
                            showGrid = false
                        },
                        weatherService: apiKeyManager.weatherService  // pass service down
                    )
                } else if let city = selectedCity {
                    MainContentView(
                        locationQuery: "\(city.lat),\(city.lon)",
                        city: city,
                        onAddCity: { newCity in
                            if !savedCities.contains(where: { $0.id == newCity.id }) {
                                savedCities.append(newCity)
                            }
                        },
                        isSaved: savedCities.contains(where: { $0.id == city.id }),
                        onBack: {
                            showGrid = true
                        },
                        weatherService: apiKeyManager.weatherService  // pass service down
                    )
                }
            } else {
                ProgressView("Loading API Key...")
                    .onAppear {
                        apiKeyManager.loadApiKey()
                    }
            }
        }
    }
}

#Preview {
    RootView()
}
