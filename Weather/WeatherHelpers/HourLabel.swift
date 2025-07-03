//
//  HourLabel.swift
//  Weather
//
//  Created by Joshua Hernandez
//
//  Helper that creates hour labels
//  Used to present current time in grid view of cities
//  Also Used to display hourly forecast hours
//  Adjusted to timezones of the selected city

import Foundation

func hourLabel(for hour: Hour, currentHourEpoch: Int, timezone: String?, hourlyForecast: Bool = true) -> String {
    let now = Date(timeIntervalSince1970: TimeInterval(currentHourEpoch))
    let hourDate = Date(timeIntervalSince1970: TimeInterval(hour.timeEpoch))
    
    var calendar = Calendar.current
    if let timezoneIdentifier = timezone,
       let timeZone = TimeZone(identifier: timezoneIdentifier) {
        calendar.timeZone = timeZone
    }
    
    // Checks ifs current time is within the hour
    // EX: 4:31 PM, the 4PM Label should be "Now"
    if calendar.isDate(hourDate, equalTo: now, toGranularity: .hour) {
        return "Now"
    }
    

    // Uses 12 Hour format with AM/PM
    // Plan to add config for 24 Hour format, or use iOS setting
    let formatter = DateFormatter()
        if let timezoneIdentifier = timezone {
            formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        }
    formatter.dateFormat = "ha"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"

    return formatter.string(from: hourDate)
}
