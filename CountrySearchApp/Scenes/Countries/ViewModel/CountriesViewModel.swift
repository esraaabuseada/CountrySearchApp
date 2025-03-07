//
//  CountriesViewModel.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation
import Combine
import CoreLocation

class CountriesViewModel: BaseViewModel, ObservableObject {
    
    @Published var countries: [Country] = []
    @Published var selectedCountries: [Country] = []  // List of selected countries
    @Published var filteredCountries: [Country] = []  // List of filtered countries based on search
    @Published var errorMessage: String? = nil  // Error message for exceeding limit
    
    private weak var service: CountriesWebServiceProtocol!
    private var locationManager: LocationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init(service: CountriesWebServiceProtocol = CountriesWebService.shared) {
        self.service = service
        super.init()
       // self.setupLocationManager()
        
    }
    
    
    func fetchCountries() {
        self.isLoading = true // Start loading
        service.fetchCountries(url: Constant.Keys.apiURL) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let countries):
               
                    self.countries = countries
                    self.filteredCountries = countries
                    self.isLoading = false // Stop loading
                    
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load countries: \(error.localizedDescription)"
                    self.isLoading = false // Stop loading
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
    func removeCountryFromSelection(country: Country) {
        selectedCountries.removeAll { $0.name == country.name }
    }
    
    private func setupLocationManager() {
        // Start location updates
               self.locationManager.startLocationUpdates()
               
               // Handle location updates and permission denial
               self.locationManager.locationPublisher()
                   .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] location in
                       self?.fetchCountryBasedOnLocation(location)
                   })
                   .store(in: &cancellables)
               
               self.locationManager.permissionDeniedPublisher()
                   .sink { [weak self] in
                     //  self?.fetchFallbackCountry()
                   }
                   .store(in: &cancellables)
    }
    
    // Fetch country data based on location coordinates
        private func fetchCountryBasedOnLocation(_ location: CLLocation) {
            isLoading = true
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            // Using a mock API URL for simplicity
            guard let url = URL(string: "\(Constant.Keys.apiURL)?lat=\(lat)&lon=\(lon)") else {
                isLoading = false
                return
            }
            
            service.fetchCountries(url: url.absoluteString) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let countries):
                    self.selectedCountries = countries
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load countries: \(error.localizedDescription)"
                        self.isLoading = false // Stop loading
                    }
                }
            }
        }
}

