//
//  DisplayHourly.swift
//  Weather
//
//  Created by Joshua Hernandez
//  Displays Hourly Forecast
//  Each Hour Provides an Hour Label
//  Image indicating Night or Day (Rain and Clouds to be implemented)
//  Temperature at that hour

import SwiftUI

struct DisplayHourly: View {
    let isDay: Bool
    let forecastDays: [ForecastDay]
    let currentWeather: Double
    let timezone: String
    var body: some View {
        let hourlyData = getHourlyForecast(from: forecastDays)
        let imageData = getImage(from: forecastDays)
        let currentHourEpoch =  Int(Date().timeIntervalSince1970)
        VStack{
            Text("Hourly Forecast")
                .foregroundStyle(isDay ? Color("Day") : Color("Night"))
                .font(.system(
                    size: maxMainVStackWidth/22.85,
                    weight: Font.Weight.medium,
                    design: Font.Design.default))
                .padding(.all, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider().background(Color.white)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(hourlyData.indices, id: \.self) { index in
                        VStack{
                            let hour = hourlyData[index]
                            Text("\(hourLabel(for: hour, currentHourEpoch: currentHourEpoch, timezone: timezone))")
                                .font(.system(
                                    size: maxMainVStackWidth/32,
                                    weight: Font.Weight.medium,
                                    design: Font.Design.default))
                                .foregroundStyle(Color.white)
                            Image(systemName: imageData[index])
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: maxMainVStackWidth/16,
                                       height: maxMainVStackWidth/16)
                            if hourLabel(for: hour, currentHourEpoch: currentHourEpoch, timezone: timezone) != "Now"{
                                Text(String(format: "%.1f°", hour.tempF))
                                    .font(.system(
                                        size: maxMainVStackWidth/32,
                                        weight: Font.Weight.medium,
                                        design: Font.Design.default))
                                    .foregroundStyle(Color.white)
                            } else {
                                Text(String(format: "%.1f°", currentWeather))
                                    .font(.system(
                                        size: maxMainVStackWidth/32,
                                        weight: Font.Weight.medium,
                                        design: Font.Design.default))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding(.vertical, 8)
                        .frame(width: maxMainVStackWidth/6.7, height: maxMainVStackWidth/4.8)
                    }.padding(.bottom, 8)
                }
            }
        }
        .frame(maxWidth: maxMainVStackWidth)
        .padding(.horizontal, 16)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}

func getHourlyForecast(from forecastDays: [ForecastDay]) -> [Hour] {
    // Get current exact time
    let currentTime = Date()
    
    // Get the start of the current hour
    let calendar = Calendar.current
    let startOfCurrentHour = calendar.date(bySetting: .minute, value: 0, of: currentTime)!
    let startOfCurrentHourEpoch = Int(startOfCurrentHour.timeIntervalSince1970)
    
    var next24Hours: [Hour] = []
    
    for day in forecastDays {
        for hour in day.hour {
            // Find Hour Objects from current hour onward for up to 25 hours
            // 25 in order to fulfill current hour up to hour of next day
            if hour.timeEpoch >= startOfCurrentHourEpoch-3600 {
                next24Hours.append(hour)
                if next24Hours.count >= 25 {
                    return next24Hours
                }
            }
        }
    }
    return next24Hours
}

func getImage(from forecastDays: [ForecastDay]) -> [String] {
    // Get current exact time
    let currentTime = Date()
    
    // Get the start of the current hour
    let calendar = Calendar.current
    let startOfCurrentHour = calendar.date(bySetting: .minute, value: 0, of: currentTime)!
    let startOfCurrentHourEpoch = Int(startOfCurrentHour.timeIntervalSince1970)
    
    var next24Images: [String] = []
    for day in forecastDays {
        for hour in day.hour {
            if hour.timeEpoch >= startOfCurrentHourEpoch - 3600 {
                let isDay = hour.isDay == 1

                let imageName: String
                if hour.willItRain == 1 {
                    imageName = isDay ? "sun.rain.fill" : "cloud.moon.rain.fill"
                } else if hour.willItSnow == 1 {
                    imageName = isDay ? "sun.snow.fill" : "cloud.snow"
                } else if hour.cloud >= 50 {
                    imageName = isDay ? "cloud.sun.fill" : "cloud.moon.fill"
                } else {
                    imageName = isDay ? "sun.max.fill" : "moon.stars.fill"
                }

                next24Images.append(imageName)

                if next24Images.count >= 25 {
                    return next24Images
                }
            }
        }
    }
    return next24Images
}
