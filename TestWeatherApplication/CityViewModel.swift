//
//  CityViewModel.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 13.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation

class CityViewModel {
    
    let location: String
    let cityModel: CityModel
    
    init(model: CityModel) {
        cityModel = model
        location = model.name + ", " + model.country
    }
    
}
