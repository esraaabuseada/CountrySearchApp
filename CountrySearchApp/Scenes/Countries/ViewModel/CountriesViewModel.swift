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
        
        self.fetchCountries()
//        self.setupLocationManager()
        
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
                self.setupLocationManager()
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
    
   func setupLocationManager() {
        // Start location updates
               self.locationManager.startLocationUpdates()
               
               // Handle location updates and permission denial
               self.locationManager.locationPublisher()
                   .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] location in
                       guard let `self` = self else { return }
                       self.findNearestCountryBasedOnLocation(location)
                   })
                   .store(in: &cancellables)
               
               self.locationManager.permissionDeniedPublisher()
                   .sink { [weak self] in
                       guard let `self` = self else { return }
                       self.errorMessage = "Please Give Location Access Permision"
                       self.fallbackCountry()
                   }
                   .store(in: &cancellables)
    }
    
    // Fetch country data based on location coordinates
    private func findNearestCountryBasedOnLocation(_ currentLocation: CLLocation) {
       
        guard !countries.isEmpty else { return }
        // Calculate distance for each country and sort by the smallest distance
                let sortedCountries = countries.map { country -> (Country, CLLocationDistance) in
                    let countryLocation = CLLocation(latitude: country.latlng?[0] ?? 0.0, longitude: country.latlng?[1] ?? 0.0)
                    let distance = currentLocation.distance(from: countryLocation)
                    return (country, distance)
                }
                .sorted { $0.1 < $1.1 }  // Sort countries by distance
        
        if let nearestCountry = sortedCountries.first?.0 {
            self.selectedCountries.append(nearestCountry)
               }
       
    }
    
    // Fallback logic when location is denied
       private func fallbackCountry() {
           // If location permission is denied, just show a default country or any other fallback
           if let firstCountry = countries.first {
               self.selectedCountries.append(firstCountry) // Fallback to the first country in the list
           }
       }
}

