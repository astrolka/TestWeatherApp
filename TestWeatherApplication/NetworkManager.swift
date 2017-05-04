

import Foundation
import ReactiveSwift
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private static let flickrKey = "988bb3304a3bae8fb3a3847d9a253b7f"
    private static let flickrSecret = "3bce4a7e699d0cf3"
    private static let googleGeocodingKey = "AIzaSyBOM9Vwyela3f0LbbNx1OLePWbRgXXyV5M"
    private static let googleAutocompleteCityNameKey = "AIzaSyDJiE9mf0s6w2Dc7oplXwUVuMJkQcEgBL4"
    private static let wetherApiKey = "ab531dac3c6c045e9501f43fa8f0742c"
    
    private lazy var flickrBaseUrl = URL(string: "https://api.flickr.com/services/rest/")
    private lazy var googleAutocompleteBaseUrl = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")
    private lazy var openWeatherBaseUrl = URL(string: "http://api.openweathermap.org/data/2.5/")
    
    func searchPhotoForCity(name cityName: String) -> SignalProducer<PhotoModel, WeatherAppError> {
        let params =
            ["method" : "flickr.photos.search",
             "api_key" : NetworkManager.flickrKey,
             "text" : cityName,
             "sort" : "relevance",
             "format" : "json",
             "nojsoncallback" : "1"]
        
        return signalProducerForRequest(url: flickrBaseUrl, parameters: params)
        { response -> PhotoModel in
            return PhotoModel(dictionary: response)
        }
    }
    
    func citySuggestionsFor(typedText text: String) -> SignalProducer<ResultModels<CityModel>, WeatherAppError> {
        let params =
            ["input" : text,
             "types" : "(cities)",
             "key" : NetworkManager.googleAutocompleteCityNameKey];
        
        return signalProducerForRequest(url: googleAutocompleteBaseUrl, parameters: params)
        { response -> ResultModels<CityModel>? in
            if let dict = response["predictions"] as? [[String : Any]] {
                return ResultModels(response: dict)
            } else {
                return nil
            }
        }
    }

    func currentWeatherFor(city cityName: String) -> SignalProducer<CurrentWeatherModel, WeatherAppError> {
        let params =
            ["units" : "metric",
             "q" : cityName,
             "APPID" : NetworkManager.wetherApiKey];
        let url = openWeatherBaseUrl?.appendingPathComponent("weather")
        return signalProducerForRequest(url: url, parameters: params)
        { response -> CurrentWeatherModel in
            return CurrentWeatherModel(response)
        }
    }

    func weatherForcastFor(city cityName: String) -> SignalProducer<ResultModels<ForecastWeatherModel>, WeatherAppError> {
        let params =
                ["units" : "metric",
                 "q" : cityName,
                 "APPID" : NetworkManager.wetherApiKey];
        let url = openWeatherBaseUrl?.appendingPathComponent("forecast")
        return signalProducerForRequest(url: url, parameters: params)
        { (response) -> ResultModels<ForecastWeatherModel>? in
            if let arrayOfDicts = response["list"] as? [[String : Any]] {
                return ResultModels(response: arrayOfDicts)
            } else {
                return nil
            }
        }
    }
    
    private func signalProducerForRequest<T>(url: URL?, parameters: [String : String], transform:@escaping ([String : Any]) -> T?) -> SignalProducer<T, WeatherAppError> {
        return SignalProducer { observer, _ in
            guard let url = url else {
                observer.send(error: WeatherAppError(localizedTitle: nil, localizedDescription: "Unsuported url format", code: 1))
                observer.sendCompleted()
                return
            }
            
            Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String : Any], let result = transform(json) {
                        observer.send(value: result)
                    }
                    observer.sendCompleted()
                case .failure:
                    if let error = response.error as? NSError {
                        observer.send(error: WeatherAppError(localizedTitle: nil, localizedDescription: error.localizedDescription, code: 1))
                    }
                    observer.sendCompleted()
                }
            }
        }
    }
    
}
