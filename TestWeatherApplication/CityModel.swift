//
//  CityModel.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 10.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

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
    
    static func ==(left: CityModel, right: CityModel) -> Bool {
        return left.name == right.name && left.country == right.country
    }
}
