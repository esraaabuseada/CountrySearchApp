//
//  UINavigationController+Extension.swift
//  iOS-EGROCARE-Pro
//
//  Created by Es on 06/03/2024.
//

import UIKit

extension UINavigationController {
    
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
      
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
    
}
