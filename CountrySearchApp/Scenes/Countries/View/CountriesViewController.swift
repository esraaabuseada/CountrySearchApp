//
//  CountriesViewController.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import UIKit
import Combine
import PanModal

class CountriesViewController: BaseViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    private var countriesViewModel: CountriesViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    
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
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countriesViewModel?.fetchCountries()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
          
        }
    
    @IBAction func addTapped(_ sender: UIButton) {
       
        self.searchBar.searchTextField.endEditing(true)
        self.dismiss(animated: true)
    }
}
// MARK: - Private
extension CountriesViewController {
    
    private func setUpTheScreen() {
      
        self.countriesTableView.delegate = self
        self.countriesTableView.dataSource = self
        self.countriesTableView.allowsSelection = true
        self.countriesTableView.allowsMultipleSelection = true
        
        self.searchBar.delegate = self
        countriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
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
            countriesViewModel?.$filteredCountries
                .sink { [weak self] countries in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        self.countriesTableView.reloadData()
                    }
                }
                .store(in: &cancellables)
        
        // Observe error message
        countriesViewModel?.$errorMessage
                  .sink { [weak self] errorMessage in
                      guard let `self` = self else { return }
                      if let errorMessage = errorMessage {
                          self.showError(message: errorMessage)
                      }
                  }
                  .store(in: &cancellables)

           
        }
    
    
    // Show error message (e.g., when the user selects more than 5 countries)
       func showError(message: String) {
           let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default))
           present(alertController, animated: true)
       }
}


extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return countriesViewModel?.filteredCountries.count ?? 0
        }

     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        if let country = countriesViewModel?.filteredCountries[indexPath.row] {
            
            cell.textLabel?.text = country.name
            
            
            // Show checkmark if the country is selected
            if let selectedCountries = countriesViewModel?.selectedCountries {
                if selectedCountries.contains(where: { $0.name == country.name }) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }
           return cell
       }

    
    // Handle row selection
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if let country = countriesViewModel?.filteredCountries[indexPath.row] {
               countriesViewModel?.toggleCountrySelection(country: country)
               
               // Ensure that no more than 5 countries can be selected
               if countriesViewModel?.selectedCountries.count ?? 0 > 5 {
                   countriesViewModel?.selectedCountries.removeLast()
                   showError(message: "You can only select up to 5 countries.")
               }
               
               tableView.reloadRows(at: [indexPath], with: .automatic)
           }
       }
       
       // Handle row deselection
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            if let country = countriesViewModel?.filteredCountries[indexPath.row] {
                countriesViewModel?.toggleCountrySelection(country: country)
            }
       }

    
 }


// MARK: - Handle search text change

extension CountriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           countriesViewModel?.searchCountries(searchText: searchText)
        //countriesTableView.reloadData()
       }
         
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchBar.text = ""
        countriesTableView.reloadData()
     }
 }

extension CountriesViewController: PanModalPresentable {
    
    
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    var allowsDragToDismiss: Bool {
        self.countriesViewModel?.selectedCountries = []
        return true
    }
    
    var allowsTapToDismiss: Bool {
        self.countriesViewModel?.selectedCountries = []
        return true
    }
}
