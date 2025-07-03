//
//  CityName.swift
//  Weather
//
//  Created by Joshua Hernandez
//

import SwiftUI

struct CityName: View {
    var city: String
    var region: String
    var body: some View {
        Text(city + ", " + region)
            .font(.system(
                size: 32,
                weight: Font.Weight.medium,
                design: Font.Design.default))
            .padding()
            .foregroundStyle(Color.white)
    }
}
