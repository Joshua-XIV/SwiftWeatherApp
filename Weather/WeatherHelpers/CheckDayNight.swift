//
//  CheckDayNight.swift
//  Weather
//
//  Created by Joshua Hernandez
//

import Foundation

func isDay(weather: WeatherResponse?) -> Bool {
    if weather?.current.isDay == 1{
        return true
    } else {
        return false
    }
}
