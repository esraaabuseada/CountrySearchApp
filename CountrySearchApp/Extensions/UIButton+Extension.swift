//
//  UIButton+Extension.swift
//  Berry Gyms
//
//  Created by Es on 19/12/2023.
//

import UIKit

extension UIButton {
    
    func setButtonActive(color: UIColor) {
        self.isEnabled = true
        self.backgroundColor = color
    }
    
    func setButtonInActive(color: UIColor) {
        self.isEnabled = false
         self.backgroundColor = color
    }
    
}
