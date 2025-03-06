//
//  CountriesWebService.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation

protocol CountriesWebServiceProtocol: AnyObject {
    
    
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void)
}

class CountriesWebService: CountriesWebServiceProtocol {
    
    static let shared = CountriesWebService()
    
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void)  {
        let url = "https://restcountries.com/v2/all"
        
        NetworkManager.shared.get(url) { (result: Result<[Country], NetworkError>) in
            switch result {
            case .success(let countries):
                completion(.success(countries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
