

import Foundation
import ReactiveSwift
import Result
import RealmSwift

class DataBaseManager {
    
    static let shared = DataBaseManager()
    private init() {}
    
    func isSuchRecord<T: Hashable>(_ model: T, forEntityType type: Object.Type) -> Bool {
        let realm = try! Realm()
        
        if realm.isEmpty {
            return false
        }
        let object = realm.object(ofType: type, forPrimaryKey: model.hashValue)
        return object != nil
    }
    
    func updatePlace(_ place: Place, withNewCurrentWeather currentWeatherModel: CurrentWeatherModel, newPhoto photoModel: PhotoModel, andForecastData forecastModel: [ForecastWeatherModel]) {
        do {
            let realm = try Realm()
            try realm.write {
                
                if place.currentWeather != nil {
                    place.currentWeather?.bindServerModel(currentWeatherModel)
                } else {
                    let currentWeather = CurrentWeather()
                    currentWeather.bindServerModel(currentWeatherModel)
                    place.currentWeather = currentWeather
                }
                
                if place.photo != nil {
                    place.photo?.bindServerModel(photoModel)
                } else {
                    let photo = Photo()
                    photo.bindServerModel(photoModel)
                    place.photo = photo
                }
                
                let minIndex = min(place.forecast.count, forecastModel.count)
                
                for i in 0..<minIndex {
                    place.forecast[i].bindServerModel(forecastModel[i])
                }
                
                if place.forecast.count > forecastModel.count {
                    place.forecast.removeSubrange(ClosedRange(uncheckedBounds: (minIndex, place.forecast.count - 1)))
                }
                if place.forecast.count < forecastModel.count {
                    for i in minIndex..<forecastModel.count {
                        let newForecast = ForecastWeather()
                        newForecast.bindServerModel(forecastModel[i])
                        place.forecast.append(newForecast)
                    }
                }
                place.lastUpdateDate = Date()
            }
        } catch let error {
            print(error)
        }
    }
    
    func writePlaceToRealm(_ model: CityModel) -> Place {
        let place = Place()
        place.bindCityModel(model)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(place)
            }
        } catch let error {
            print(error)
        }
        return place
    }
    
    func getAllPlaces() -> Results<Place> {
        let realm = try! Realm()
        return realm.objects(Place.self)
    }
    
    func deletePlace(_ place: Place) {
        do {
            let realm = try Realm()
            try realm.write {
                if let photo = place.photo {
                    realm.delete(photo)
                }
                if let currentWeather = place.currentWeather {
                    realm.delete(currentWeather)
                }
                for forecast in place.forecast {
                    realm.delete(forecast)
                }
                realm.delete(place)
            }
        } catch let error {
            print(error)
        }
    }

    private func writeToRealm<T: Object>(_ object: T) -> SignalProducer<T, NSError> {
        return SignalProducer { observer, _ in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(object)
                }
                observer.send(value: object)
                observer.sendCompleted()
            } catch let error {
                observer.send(error: error as NSError)
                observer.sendCompleted()
            }
        }
    }
    
}
