//
//  MockCountriesWebService.swift
//  CountrySearchAppTests
//
//  Created by Es on 07/03/2025.
//

import Foundation
import Combine
@testable import CountrySearchApp

class MockCountriesWebService: CountriesWebServiceProtocol {
    
    var result: Result<[Country], Error> = .success([])

    func fetchCountries(url: String, completion: @escaping (Result<[Country], Error>) -> Void) {
        completion(result)
    }
}
