

import Foundation

class CityViewModel {
    
    var location: String
    let cityModel: CityModel
    
    init(model: CityModel) {
        cityModel = model
        location = ""
        if let cityName = model.name {
            location.append(cityName)
        }
        if let countryName = model.country {
            location.append(", \(countryName)")
        }
    }
    
}
