//
//  TemperatureWithImage.swift
//  Weather
//
//  Created by Joshua Hernandez.
//

import SwiftUI

struct TemperatureWithImage: View {
    var temperatute: Double
    var isDay: Bool
    var body: some View {
        if isDay {
            Image(systemName: "sun.max.fill")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        } else {
            Image(systemName: "moon.stars")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(.white)
        }
        
        Text(String(temperatute)+"°")
            .font(.system(
                size: 50,
                weight: Font.Weight.medium,
                design: Font.Design.default))
            .foregroundStyle(Color.white)
    }
}
