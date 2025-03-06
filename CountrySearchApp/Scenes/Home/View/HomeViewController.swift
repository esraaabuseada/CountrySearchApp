//
//  HomeViewController.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var countriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func addCountryTapped(_ sender: UIButton) {
        if let viewController = Container.getCountriesViewControllerr() as? CountriesViewController {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.presentPanModal(viewController)
            })
            
        }
    }
  
   

}
