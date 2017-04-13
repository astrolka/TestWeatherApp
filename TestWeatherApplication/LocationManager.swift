//
//  LocationManager.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 10.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import MapKit
import ReactiveSwift
import Result

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private override init() {
        geocoder = CLGeocoder()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 500
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
        
    }
    
    func getLocationSignal() -> Signal<CityModel?, NoError> {
        return locationProperty.signal
    }

    private let geocoder: CLGeocoder!
    private let locationManager: CLLocationManager!
    private let locationProperty = MutableProperty<CityModel?>(nil)
    
    private func sendCityWith(location: CLLocation) {
        
        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if error != nil {
                return
            }
            guard let temp = placemarks, let placemark = temp.first, let country = placemark.country, let locality = placemark.locality else {
                return
            }
            self?.locationProperty.value = CityModel(countryName: country, cityName: locality)
        }
        
    }

    //MARK: - CLLocationManagerDelegate
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            sendCityWith(location: locations.last!)
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
        geocoder.cancelGeocode()
    }
    
}
