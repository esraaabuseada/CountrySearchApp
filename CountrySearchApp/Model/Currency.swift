//
//  Currency.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation

struct Currency: Codable {
    
    let code: String
    let name: String
    
    enum CodingKeys: String, CodingKey {

        case code
        case name

    }
}
