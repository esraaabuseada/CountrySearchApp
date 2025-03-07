//
//  AppManager.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation
import UIKit


class AppManager: NSObject {
    
    @objc static let shared: AppManager = AppManager()
    var window: UIWindow?
   
    
    static func initWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.shared.window = window
    }
    
    @available(iOS 13.0, *)
    static func initWindow(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        self.shared.window = window
    }
    
    class func setRootViewController(view: UIViewController) {
        
        shared.window?.rootViewController = view
        shared.window?.makeKeyAndVisible()
    }
    
    class func getWindow() -> UIWindow {
        shared.window?.backgroundColor = .white
        return shared.window ?? UIWindow()
    }
    
}
