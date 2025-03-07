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
    private var country: Country?
    
    
    @IBOutlet private weak var capitalLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindCell(country: Country, delgate: HomeCellDelegate, canDelete: Bool = true) {
        self.country = country
        self.delegate = delgate
        
        self.capitalLabel.text = country.capital
        self.currencyLabel.text = country.currencies?[0].code
        
        if canDelete {
            self.deleteButton.isHidden = false
        } else {
            self.deleteButton.isHidden = true
        }
    }
    
    @IBAction func deleteContryTapped(_ sender: UIButton) {
        if let country = country {
            delegate?.deleteContry(country: country)
        }
    }
}
