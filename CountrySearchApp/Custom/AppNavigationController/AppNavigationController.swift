//
//  AppNavigationController.swift
//  OnOne-iOs
//
//  Created by Esraa Abuseada on 20/03/2021.
//

import Foundation
import UIKit

class AppNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension UINavigationItem {
    
    func clearBackBarButtonTitle() {
        let backBarButton: UIBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.backBarButtonItem = backBarButton
    }
}
