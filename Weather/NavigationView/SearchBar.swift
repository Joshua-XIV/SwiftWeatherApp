//
//  SearchBar.swift
//  Weather
//
//  Created by Joshua Hernandez
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchInput: String
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .frame(width: maxMainVStackWidth/18, height: maxMainVStackWidth/18)
            TextField("Search for a city", text: $searchInput)
                .foregroundStyle(.white)
                .frame(width: maxMainVStackWidth, height: maxMainVStackWidth/16)
        }
        .padding(.all, 6)
        .background(.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
