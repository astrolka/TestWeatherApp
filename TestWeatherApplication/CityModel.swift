

import Foundation
import MapKit
import SwiftyJSON

class CityModel: ServerModelProtocol {
    let country: String
    let name: String    
    
    required init(_ response: [String : Any]) {
        let jsonData = JSON(response)
        self.name = jsonData["structured_formatting"]["main_text"].stringValue
        self.country = jsonData["structured_formatting"]["secondary_text"].stringValue
    }
    
    init(countryName: String, cityName: String) {
        self.country = countryName
        self.name = cityName
    }
}

extension CityModel: Hashable {
    var hashValue: Int {
        return "\(name)\(country)".hashValue
    }
    static func ==(lhs: CityModel, rhs: CityModel) -> Bool {
        return lhs.name == rhs.name && lhs.country == rhs.country
    }
}
