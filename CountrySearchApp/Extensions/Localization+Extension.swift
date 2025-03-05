//
//  Localization+Extension.swift
//  Berry Gyms
//
//  Created by Es on 02/12/2023.
//

import Foundation
import UIKit

extension Bundle {

    @objc
    func appLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {

        let currentLangouge = LocalizationManager.currentLanguage()
        var bundle = Bundle.main
        if let path = Bundle.main.path(forResource: currentLangouge.languageCode, ofType: "lproj"),
            let appBundle = Bundle(path: path) {
            bundle = appBundle
        }
        return bundle.appLocalizedString(forKey: key, value: value, table: tableName)
    }
}

extension UIApplication {

    @objc var appUserInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        
        var direction: UIUserInterfaceLayoutDirection = .leftToRight
        if LocalizationManager.currentLanguage() == .arabic {
            direction = .rightToLeft
        }
        return   direction
    }
}

extension UICollectionViewFlowLayout {
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        if LocalizationManager.currentLanguage() == .arabic {
            return true
        }
        return false
    }
}
