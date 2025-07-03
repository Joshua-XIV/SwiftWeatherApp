//
//  Background.swift
//  Weather
//
//  Created by Joshua Hernandez
//

import SwiftUI

struct Backgound : View {
    var isDay: Bool
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: isDay ? [Color("Day"), .blue] : [Color("Night"), .gray]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        .ignoresSafeArea(.all)
    }
}
