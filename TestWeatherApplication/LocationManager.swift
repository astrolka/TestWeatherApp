

import Foundation
import MapKit
import ReactiveSwift
import Result

class LocationManager: NSObject {
    
    private let geocoder: CLGeocoder
    private let locationManager: CLLocationManager
    private let (locationSignal, locationObserver): (Signal<CityModel, NoError>, Observer<CityModel, NoError>)
    
    static let shared = LocationManager()
    private override init() {
        geocoder = CLGeocoder()
        locationManager = CLLocationManager()
        (locationSignal, locationObserver) = Signal<CityModel, NoError>.pipe()
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 500
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    fileprivate func reverseGeocodeLocation(_ location: CLLocation) {
        
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
            let city = CityModel(countryName: country, cityName: locality)
            self?.locationObserver.send(value: city)
        }
        
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
        geocoder.cancelGeocode()
    }
    
    //MARK: - Public methods
    
    func getLocationSignal() -> Signal<CityModel, NoError> {
        return locationSignal
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            reverseGeocodeLocation(location)
        }
    }
    
}
