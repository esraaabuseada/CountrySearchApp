//
//  NSObject+Extension.swift
//  Berry Gyms
//
//  Created by Es on 07/11/2023.
//

import Foundation

extension NSObject {
    
    // return Class Name
    public static var className: String {
        return String(describing: self)
    }
}
