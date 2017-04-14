

import Foundation

class CityViewModel {
    
    let location: String
    let cityModel: CityModel
    
    init(model: CityModel) {
        cityModel = model
        location = model.name + ", " + model.country
    }
    
}
