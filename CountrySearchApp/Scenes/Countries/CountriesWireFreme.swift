//
//  CountriesWireFreme.swift
//  CountrySearchApp
//
//  Created by Es on 07/03/2025.
//

import Foundation
import UIKit

class CountriesModule {

    class func createModule(viewModel: CountriesViewModel) -> UIViewController {
        let view = CountriesViewController(viewModel: viewModel)
        return view

    }
}
