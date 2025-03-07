//
//  UIView+Extension.swift
//  Berry Gyms
//
//  Created by Es on 06/11/2023.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornurRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    var isHiddenIfNeeded: Bool {
        get {
            return self.isHidden
        }
        set {
            if self.isHidden != newValue {
                self.isHidden = newValue
            }
        }
    }
    
    func loadViewFromNib(nibName: String) -> UIView? {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setRounded() {
           self.layer.masksToBounds = false
           self.layer.cornerRadius = self.frame.height / 2
           self.clipsToBounds = true
       }
    
    func smoothRoundCorners(to radius: CGFloat) {
      let maskLayer = CAShapeLayer()
      maskLayer.path = UIBezierPath(
        roundedRect: bounds,
        cornerRadius: radius
      ).cgPath

      layer.mask = maskLayer
    }
}
