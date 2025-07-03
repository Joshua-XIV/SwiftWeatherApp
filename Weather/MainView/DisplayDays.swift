//
//  DisplayDays.swift
//  Weather
//
//  Created by Joshua Hernandez
//

import SwiftUI

struct DisplayDays: View {
    let isDay: Bool
    let forecastDays: [ForecastDay]
    let timezoneID: String
    var body: some View {
            VStack(spacing: 0){
                Text("10-Day Forecast")
                    .foregroundStyle(isDay ? Color("Day") : Color("Night"))
                    .font(.system(
                        size: maxMainVStackWidth/22.85,
                        weight: Font.Weight.medium,
                        design: Font.Design.default))
                    .padding(.all, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider().background(Color.white)
                ForEach(forecastDays.prefix(totalDays).indices, id:\.self) { index in
                    let day = forecastDays[index]
                    HStack {
                        Text(isToday(date: day.date, timezoneID: timezoneID) ? "Today" : formatDateToWeekday(date: day.date, timezoneID: timezoneID))
                            .foregroundStyle(Color.white)
                            .font(.system(
                                size: maxMainVStackWidth/16,
                                weight: Font.Weight.medium,
                                design: Font.Design.serif))
                            .frame(minWidth: maxMainVStackWidth/4)
                        Image(systemName: "sun.max.fill")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: maxMainVStackWidth/12.8,
                                   height: maxMainVStackWidth/12.8)
                            .padding(.trailing, maxMainVStackWidth/20)
                        Text(String("\(Int(day.day.mintempF))° - \(Int(day.day.maxtempF))°"))
                            .foregroundStyle(Color.white)
                            .font(.system(
                                size: maxMainVStackWidth/11.4,
                                weight: Font.Weight.medium,
                                design: Font.Design.default))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, maxMainVStackWidth/53.3)
                    
                if index < forecastDays.prefix(totalDays).count - 1 {
                    Divider().background(Color.white)
                }
            }
        }        
        .frame(maxWidth: maxMainVStackWidth)
        .padding(.horizontal, 16)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}

func formatDate(date: String) -> String{
    let start = date.index(date.startIndex, offsetBy: 5)
    let formatted = String(date[start...]) // 2015-05-23 to 05-23
    return formatted
}

func formatDateToWeekday(date: String, timezoneID: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(identifier: timezoneID) ?? .current
    formatter.locale = Locale.current

    guard let dateObj = formatter.date(from: date) else {
        return formatDate(date: date)
    }

    formatter.dateFormat = "EEE"
    return formatter.string(from: dateObj)
}

func isToday(date: String, timezoneID: String) -> Bool{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // input
    formatter.timeZone = TimeZone(identifier: timezoneID) ?? .current
    formatter.locale = Locale.current
    
    guard let inputDate = formatter.date(from: date) else {
        return false
    }
    
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: timezoneID) ?? .current
    return calendar.isDateInToday(inputDate)
}
