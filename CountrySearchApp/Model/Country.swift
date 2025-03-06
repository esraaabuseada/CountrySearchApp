//
//  Country.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation

struct Country: Codable, Identifiable {
    var id: String { name }
    let name: String
    let capital: String?
    let currencies: [Currency] = []
   
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case capital
        case currencies
       
    }
    
}


