//
//  Loader.swift
//  OnOne-iOs
//
//  Created by Esraa Abuseada on 20/03/2021.
//

import UIKit

class Loader: NSObject {
    
    static var sharedViewSpinner: UIView?
    private static var onView = UIView()
    
    class func show (onView: UIView) {
        
        self.onView = onView
        if sharedViewSpinner != nil {
            sharedViewSpinner?.removeFromSuperview()
        }
        
        let spinnerView = UIView(frame: UIScreen.main.bounds)
        spinnerView.backgroundColor = UIColor.gray
    
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = Asset.Colors.primaryAppColor.color
        activityIndicator.startAnimating()
        activityIndicator.center = viewBackgroundLoading.center
        viewBackgroundLoading.addSubview(activityIndicator)
        
        viewBackgroundLoading.center = spinnerView.center
        viewBackgroundLoading.backgroundColor = Asset.Colors.secondryColor.color
        viewBackgroundLoading.alpha = 0.8
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        spinnerView.backgroundColor = Asset.Colors.loaderBackground.color
        spinnerView.alpha = 1
        spinnerView.addSubview(viewBackgroundLoading)
        onView.addSubview(spinnerView)
        
        sharedViewSpinner = spinnerView
    }
    
    class func hide() {
        // native
        sharedViewSpinner?.removeFromSuperview()
        sharedViewSpinner = nil
    }
}
