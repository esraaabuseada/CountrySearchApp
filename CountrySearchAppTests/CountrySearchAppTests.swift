//
//  CountrySearchAppTests.swift
//  CountrySearchAppTests
//
//  Created by Es on 05/03/2025.
//

import XCTest
import Combine
@testable import CountrySearchApp

final class CountrySearchAppTests: XCTestCase {

    var viewModel: CountriesViewModel!
        var mockService: MockCountriesWebService!
        
        var cancellables: Set<AnyCancellable>!

        override func setUp() {
            super.setUp()
            
            cancellables = []
            
            // Set up mock service and location manager
            mockService = MockCountriesWebService()
            
            
            // Initialize the ViewModel with mock dependencies
            viewModel = CountriesViewModel(service: mockService)
            
        }

        override func tearDown() {
            cancellables = nil
            viewModel = nil
            mockService = nil
            
            super.tearDown()
        }

        // Test: Fetch countries successfully
        func testFetchCountriesSuccess() {
            // Prepare mock data
            let country = Country(name: "Canada",
                                  capital: "Ottawa",
                                  currencies: [Currency(code: "CAD", name: "Canadian dollar")],
                                  latlng: [60.0, -95.0])
            mockService.result = .success([country])

            // Call fetchCountries()
            viewModel.fetchCountries()
            
            // Verify the countries list is updated
            XCTAssertEqual(viewModel.countries.count, 1)
            XCTAssertEqual(viewModel.countries.first?.name, "Canada")
        }

        // Test: Fetch countries failure
        func testFetchCountriesFailure() {
            // Simulate failure response
            mockService.result = .failure(NSError(domain: "TestError", code: 0, userInfo: nil))
            
            // Call fetchCountries()
            viewModel.fetchCountries()
            
            // Verify the error message is set
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertEqual(viewModel.errorMessage, "Failed to load countries: The operation couldn’t be completed. (TestError error 0.)")
        }

        // Test: Search countries
        func testSearchCountries() {
            // Prepare mock data
            let country1 = Country(name: "Canada",
                                   capital: "Ottawa",
                                   currencies: [Currency(code: "CAD", name: "Canadian dollar")],
                                   latlng: [60.0, -95.0])
            
            let country2 = Country(name: "Mexico",
                                   capital: "Mexico City",
                                   currencies: [Currency(code: "MXN", name: "Mexican peso")],
                                   latlng: [23.0, -102.0])
            viewModel.countries = [country1, country2]
            
            // Search for "Canada"
            viewModel.searchCountries(searchText: "Canada")
            
            // Verify filtered countries
            XCTAssertEqual(viewModel.filteredCountries.count, 1)
            XCTAssertEqual(viewModel.filteredCountries.first?.name, "Canada")
        }

        // Test: Toggle country selection when adding
        func testToggleCountrySelectionAdd() {
            let country = Country(name: "Canada",
                                  capital: "Ottawa",
                                  currencies: [Currency(code: "CAD", name: "Canadian dollar")],
                                  latlng: [60.0, -95.0])
            
            // Add country to selection
            viewModel.toggleCountrySelection(country: country)
            
            // Verify country is added
            XCTAssertEqual(viewModel.selectedCountries.count, 1)
            XCTAssertEqual(viewModel.selectedCountries.first?.name, "Canada")
        }

        // Test: Toggle country selection when removing
        func testToggleCountrySelectionRemove() {
            let country = Country(name: "Canada",
                                  capital: "Ottawa",
                                  currencies: [Currency(code: "CAD", name: "Canadian dollar")],
                                  latlng: [60.0, -95.0])
            
            // Add country first
            viewModel.toggleCountrySelection(country: country)
            
            // Remove country from selection
            viewModel.toggleCountrySelection(country: country)
            
            // Verify country is removed
            XCTAssertEqual(viewModel.selectedCountries.count, 0)
        }

        // Test: Toggle country selection exceeding limit
        func testToggleCountrySelectionLimit() {
            let country = Country(name: "Canada",
                                  capital: "Ottawa",
                                  currencies: [Currency(code: "CAD", name: "Canadian dollar")],
                                  latlng: [60.0, -95.0])
            
            // Add countries up to limit (5)
            for i in 1...5 {
                let country = Country(name: "Country \(i)", capital: "Capital \(i)", currencies: [Currency(code: "CODE", name: "Currency name")], latlng: [0.0, 0.0])
                viewModel.toggleCountrySelection(country: country)
            }
            
            // Attempt to add a 6th country
            viewModel.toggleCountrySelection(country: country)
            
            // Verify error message for exceeding limit
            XCTAssertEqual(viewModel.errorMessage, "You can only select up to 5 countries.")
        }

        
}
