//
//  HomeCell.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import UIKit

protocol HomeCellDelegate: AnyObject {
    func deleteContry(country: Country)
}

class HomeCell: UITableViewCell {

    private weak var delegate: HomeCellDelegate?
    private var country = Country(name: "", capital: "", currencies: [])
    
    
    @IBOutlet private weak var capitalLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindCell(country: Country, delgate: HomeCellDelegate) {
        self.country = country
        self.delegate = delgate
        
        self.capitalLabel.text = country.capital
        self.currencyLabel.text = country.currencies?[0].code
    }
    
    @IBAction func deleteContryTapped(_ sender: UIButton) {
        delegate?.deleteContry(country: country)
    }
}
