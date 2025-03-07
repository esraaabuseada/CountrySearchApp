//
//  HomeWireFrame.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation
import UIKit

class HomeModule {

    class func createModule(viewModel: CountriesViewModel) -> UIViewController {
        let view = HomeViewController(viewModel: viewModel)
        return view

    }
}
