//
//  Place.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 10.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import RealmSwift

class Place: Object {
    dynamic var countryName = ""
    dynamic var cityName = ""
    dynamic var lastUpdateDate = Date()
    dynamic var photo: Photo?
    dynamic var currentWeather: CurrentWeather?
    var forecast = List<ForecastWeather>()
    

    func bindCityModel(_ city: CityModel) {
        self.cityName = city.name
        self.countryName = city.country
    }
}
