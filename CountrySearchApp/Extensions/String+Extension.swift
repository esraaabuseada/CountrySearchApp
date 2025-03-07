//
//  String+Extension.swift
//  Berry Gyms
//
//  Created by Es on 18/12/2023.
//

import Foundation
import UIKit

extension String {
    
    func getString(array : [String]) -> String {
            let stringArray = array.map{ String($0) }
            return stringArray.joined(separator: ",")
        }
    
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
               let escapedURL = URL(string: urlEscapedString) {
                return escapedURL
            }
        }
        return nil
    }
    
    
    
    func width (font: UIFont, height: Double) -> CGFloat {
        
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        return NSString(string: self).boundingRect( with: size,
                                                    options: .usesLineFragmentOrigin,
                                                    attributes: [.font: font], context: nil).size.width
    }

    
    func isContainsOnlyLettersAndWhitespace() -> Bool {
            let allowed = CharacterSet.letters.union(.whitespaces)
            return unicodeScalars.allSatisfy(allowed.contains)
        }

}
