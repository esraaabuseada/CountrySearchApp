//
//  CountriesViewModel.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation
import Combine


class CountryViewModel: ObservableObject {
    
    private weak var service: CountriesWebServiceProtocol!
    
    @Published var countries: [Country] = []
    @Published var selectedCountries: [Country] = []  // List of selected countries
    @Published var filteredCountries: [Country] = []  // List of filtered countries based on search
    @Published var errorMessage: String? = nil  // Error message for exceeding limit
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: CountriesWebServiceProtocol = CountriesWebService.shared) {
        self.service = service
        fetchCountries()
    }
    
    
    func fetchCountries() {
        
        service.fetchCountries { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let countries):
                DispatchQueue.main.async {
                    self.countries = countries
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load countries: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Handle search text changes and filter countries
    func searchCountries(searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    // Add country to the selected list if the limit is not reached
    func toggleCountrySelection(country: Country) {
        if selectedCountries.contains(where: { $0.name == country.name }) {
            removeCountryFromSelection(country: country)
        } else {
            addCountryToSelection(country: country)
        }
    }
    
    // Add country to the selected list
    private func addCountryToSelection(country: Country) {
        if selectedCountries.count < 5 {
            selectedCountries.append(country)
        } else {
            errorMessage = "You can only select up to 5 countries."
        }
    }
    
    // Remove country from the selected list
    private func removeCountryFromSelection(country: Country) {
        selectedCountries.removeAll { $0.name == country.name }
    }
}

