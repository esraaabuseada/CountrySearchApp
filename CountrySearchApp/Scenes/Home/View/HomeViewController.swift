//
//  HomeViewController.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import UIKit
import Combine
import SwiftUI

class HomeViewController: BaseViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    private var countriesViewModel: CountriesViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - IBOutlets
    @IBOutlet private weak var countriesTableView: UITableView!
    
    // MARK: - View controller init methods
    init(viewModel: CountriesViewModel) {
        self.countriesViewModel = viewModel
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTheScreen()
        bindViewModel()
//        countriesViewModel?.fetchCountries()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
          
        }
    
    @IBAction func addCountryTapped(_ sender: UIButton) {
        if let viewModel = self.countriesViewModel {
            if let viewController = Container.getCountriesViewControllerr(viewModel: viewModel) as? CountriesViewController {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.presentPanModal(viewController)
                })
                
            }
        }
    }
  
   

}

// MARK: - Private
extension HomeViewController {
    
    private func setUpTheScreen() {
      
        self.countriesTableView.delegate = self
        self.countriesTableView.dataSource = self
        self.countriesTableView.allowsSelection = true
       
        countriesTableView.register(UINib(nibName:
                                           HomeCell.className,
                                       bundle: nil),
                                 forCellReuseIdentifier: HomeCell.className)
        self.countriesTableView.reloadData()
        
    }
    
    private func bindViewModel() {
        // Subscribe to the isLoading state to show/hide the loading indicator
        countriesViewModel?.$isLoading
            .sink { [weak self] isLoading in
                guard let `self` = self else { return }
                if isLoading {
                    self.showLoader(view: self.view)
                } else {
                    self.hideLoader()
                }
            }
            .store(in: &cancellables)
        
            // Subscribe to changes in the countries array
            countriesViewModel?.$selectedCountries
                .sink { [weak self] countries in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        self.countriesTableView.reloadData()
                    }
                }
                .store(in: &cancellables)
        
//        // Observe error message
//        countriesViewModel?.$errorMessage
//                  .sink { [weak self] errorMessage in
//                      guard let `self` = self else { return }
//                      if let errorMessage = errorMessage {
//                          self.showError(message: errorMessage)
//                      }
//                  }
//                  .store(in: &cancellables)

           
        }
    
    // Navigate to the SwiftUI detail view when a row is tapped
      private func goToCountryDetails(country: Country) {
           let swiftUIView = CountryDetailView(country: country)
           let hostingController = UIHostingController(rootView: swiftUIView)
          DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
              self.present(hostingController, animated: true, completion: nil)
          })
       }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return countriesViewModel?.selectedCountries.count ?? 0
        }

     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(
             withIdentifier: HomeCell.className)
                 as? HomeCell else { return UITableViewCell() }
         
         if let country = countriesViewModel?.selectedCountries[indexPath.row] {
             if indexPath.row == 0 {
                 cell.bindCell(country: country, delgate: self, canDelete: false)
             } else {
                 cell.bindCell(country: country, delgate: self)
             }

         }
           return cell
       }

    
    // Handle row selection
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if let country = countriesViewModel?.selectedCountries[indexPath.row] {
               // goto Details Screen
               self.goToCountryDetails(country: country)
           }
       }
       
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Allow editing (deleting) rows
        if indexPath.row == 0 {
            // do not delete first country of current location
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let country = countriesViewModel?.selectedCountries[indexPath.row] {
                self.countriesViewModel?.removeCountryFromSelection(country: country)
            }
        }
    }
    
 }

extension HomeViewController: HomeCellDelegate {
    func deleteContry(country: Country) {
        self.countriesViewModel?.removeCountryFromSelection(country: country)
    }
    
    
}
