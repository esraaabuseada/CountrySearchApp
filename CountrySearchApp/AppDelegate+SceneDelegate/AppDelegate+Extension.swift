//
//  AppDelegate+Extension.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation
import IQKeyboardManagerSwift

extension AppDelegate {
    
    func initNetwork() {
        NetworkManager.shared = NetworkManager()
    }
    
    func setUpKeyboard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = Asset.Colors.primaryColor.color
    }
    
    func setRoot() {
        AppManager.initWindow()
        self.window = AppManager.getWindow()
        AppManager.setRootViewController(view: HomeViewController())
    }
    
    
    
}
