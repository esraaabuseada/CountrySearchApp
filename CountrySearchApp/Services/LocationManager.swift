//
//  LocationManager.swift
//  CountrySearchApp
//
//  Created by Es on 07/03/2025.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager?
    private var locationSubject = PassthroughSubject<CLLocation, Error>()
    private var permissionDeniedSubject = PassthroughSubject<Void, Never>()
    private var currentLocation: CLLocation?
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager?.stopUpdatingLocation()
    }
    
    // Output location to the subscribers
    func locationPublisher() -> AnyPublisher<CLLocation, Error> {
        return locationSubject.eraseToAnyPublisher()
    }
    
    // Output permission denied to the subscribers
    func permissionDeniedPublisher() -> AnyPublisher<Void, Never> {
        return permissionDeniedSubject.eraseToAnyPublisher()
    }
    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationSubject.send(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location fetch error
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            permissionDeniedSubject.send()
        }
    }
}
