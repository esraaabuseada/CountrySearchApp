//
//  Container.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation
import UIKit

class Container {
    
   
    class func getCountriesViewControllerr(
        viewModel: CountriesViewModel = CountriesViewModel()) -> UIViewController {
            let viewController = CountriesModule.createModule(viewModel: viewModel)
        return viewController
    }
    
    class func embedVCInNavController(_ viewController: UIViewController) -> UIViewController {
        let nav = AppNavigationController(rootViewController: viewController)
        return nav
    }
}
