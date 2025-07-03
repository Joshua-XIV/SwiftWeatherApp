//
//  DisplayInfo.swift
//  Weather
//
//  Created by Joshua Hernandez on 5/24/25.
//

import SwiftUI

struct DisplayInfo: View {
    let isDay: Bool
    let weatherInfo: String
    let text: String
    var body: some View {
        VStack{
            Text(text)
                .foregroundStyle(isDay ? Color("Day") : Color("Night"))
                .padding(.top, 4)
            Divider().background(Color.white)
            Spacer()
            Text(weatherInfo)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: maxMainVStackWidth/12))
                .padding(6)
            Spacer()
        }
        .frame(width: maxMainVStackWidth/2.3, height: maxMainVStackWidth/2)
        .padding(.horizontal, 16)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}
