//
//  BaseViewController.swift
//  iOS-EGROCARE-Pro
//
//  Created by Es on 07/02/2024.
//

import Foundation
import UIKit


class BaseViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
        
  
    func dismissKeyBoard() {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
    }
    
}

extension BaseViewController: LoaderProtocol {
    
    func showLoader(view: UIView) {
        Loader.show(onView: view)
    }
    
    func hideLoader() {
        Loader.hide()
    }
}

