//
//  CurrentTimeLabell.swift
//  Weather
//
//  Created by Joshua Hernandez
//

import Foundation

func currentTime(timeEpoch: Int, timezone: String?, use24HourFormat: Bool = false) -> String {
    let formatter = DateFormatter()
    
    // Set timezone if provided
    if let timezoneIdentifier = timezone {
        formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
    }
    
    // Choose format based on preference
    formatter.dateFormat = use24HourFormat ? "HH:mm" : "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeEpoch)))
}
