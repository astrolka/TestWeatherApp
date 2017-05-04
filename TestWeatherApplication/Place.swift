

import Foundation
import RealmSwift

class Place: Object {
    dynamic var countryName = ""
    dynamic var cityName = ""
    dynamic var id = 0
    dynamic var lastUpdateDate = Date()
    dynamic var photo: Photo?
    dynamic var currentWeather: CurrentWeather?
    var forecast = List<ForecastWeather>()
    
    override static func primaryKey() -> String? {
        return "id"
    }

    func bindCityModel(_ city: CityModel) {
        guard let cityName = city.name, let countryName = city.country else {
            return
        }
        self.cityName = cityName
        self.countryName = countryName
        self.id = "\(city.name)\(city.country)".hashValue
    }
}
