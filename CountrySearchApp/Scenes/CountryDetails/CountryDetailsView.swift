//
//  CountryDetailsView.swift
//  CountrySearchApp
//
//  Created by Es on 07/03/2025.
//

import Foundation
import SwiftUI


struct CountryDetailView: View {
    // Country data passed from the main view
    var country: Country
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Text("Capital:")
                    .font(.title)
                    .foregroundColor(Asset.Colors.titlesTextColor.swiftUIColor)
                
                Text("\(country.capital ?? "")")
                    .font(.title)
                    
            }.padding()
            
            HStack {
                Text("Currency:")
                .font(.title2)
                .foregroundColor(Asset.Colors.titlesTextColor.swiftUIColor)
                
                Text("\(country.currencies?[0].code ?? "")")
                .font(.title2)
                
            }.padding()
            
            Spacer()
        }
        
    }
}

