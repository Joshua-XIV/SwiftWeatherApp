//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Joshua Hernandez on 5/19/25.
//

import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {
    
    func testWeatherFetchReturnsData() async throws {
        let service = WeatherService()
        let weather: WeatherResponse? = await service.fetchWeather(for: "Austin")
        
        XCTAssertNotNil(weather, "Weather should not be nil for a valid city.")
        XCTAssertEqual(weather?.location.name, "Austin", "City name should match.")
    }
    
    func testCitySearchReturnsResults() async throws {
        let service = AutoCompleteService()
        let results: [AutoCompleteRespone]? = await service.fetchSearch(for: "New York")
        
        XCTAssertFalse(results?.isEmpty ?? true, "Search results should not be empty.")
    }

}
