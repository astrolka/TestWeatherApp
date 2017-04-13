//
//  ViewModelManager.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 10.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ViewModelManager {
    
    static let shared = ViewModelManager()
    private init() {}
    
    func placeChangedSignal() -> Signal<CityModel?, NoError> {
        let signal = LocationManager.shared.getLocationSignal()
        
        return signal.skipRepeats { (oldCity, newCity) -> Bool in
            guard let oldCity = oldCity, let newCity = newCity else {
                return true
            }
            return oldCity == newCity
        }
        
    }
    
    func isValidNew(city: CityModel?) -> Bool {
        if let city = city {
            return !DataBaseManager.shared.isDuplicate(city: city)
        } else {
            return false
        }
        
    }
    
    func placeForCityModel(_ city: CityModel) -> Place {
        return DataBaseManager.shared.writePlaceToRealm(city)
    }
    
    func getPlaces() -> [Place] {
        return Array(DataBaseManager.shared.getAllPlaces())
    }
    
    func updateDataForPlace(_ place: Place) -> SignalProducer<Place, NSError> {
        
        let components = Calendar.current.dateComponents([.minute], from: place.lastUpdateDate, to: Date())

        if let minutes = components.minute, minutes >= 20 || place.forecast.count == 0 || place.photo == nil || place.currentWeather == nil {
            return refreshPlaceInDataBase(place)
        } else {
            return SignalProducer { observer, _ in
                observer.sendCompleted()
            }
        }
    }

    func getSugestionsForText(_ text: String) -> SignalProducer<ResultModels<CityModel>, NSError> {
        return NetworkManager.shared.citySuggestionsFor(typedText: text)
    }

    private func refreshPlaceInDataBase(_ place: Place) -> SignalProducer<Place, NSError> {
        let requestProducer = SignalProducer.zip(NetworkManager.shared.currentWeatherFor(city: place.cityName), NetworkManager.shared.weatherForcastFor(city: place.cityName), NetworkManager.shared.searchPhotoForCity(name: place.cityName))
        return SignalProducer({ (observer, _) in
            requestProducer.startWithResult { (result) in
                switch result {
                case .success(let current, let wrapper, let photo):
                    let forecast = wrapper.results
                    DataBaseManager.shared.updatePlace(place, withNewCurrentWeather: current, newPhoto: photo, andForecastData: forecast)
                    observer.send(value: place)
                    observer.sendCompleted()
                case .failure(let error):
                    print(error)
                    observer.send(error: error)
                    observer.sendCompleted()
                }
            }
        })
    }
        
}