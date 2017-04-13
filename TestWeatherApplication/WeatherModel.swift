//
//  WeatherModel.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 10.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommonWeatherModel {
    var temperature: Double
    var pressure: Double
    var humidity: Int
    var windSpeed: Double
    var icon: String
    var info: String
    
    init(_ responseObject: [String : Any]) {
        let jsonData = JSON(responseObject)
        self.temperature = jsonData["main"]["temp"].doubleValue
        self.pressure = jsonData["main"]["pressure"].doubleValue
        self.humidity = jsonData["main"]["humidity"].intValue
        self.windSpeed = jsonData["wind"]["speed"].doubleValue
        self.icon = jsonData["weather"][0]["icon"].stringValue
        self.info = jsonData["weather"][0]["description"].stringValue
    }
    
}

class CurrentWeatherModel: CommonWeatherModel {
    
    var visibility: Int
    
    override init(_ responseObject: [String : Any]) {
        let jsonData = JSON(responseObject)
        self.visibility = jsonData["visibility"].intValue
        super.init(responseObject)
    }
}

class ForecastWeatherModel: CommonWeatherModel, ServerModelProtocol {
    var dateInterval: Int
    
    override required init(_ responseObject: [String : Any]) {
        let jsonData = JSON(responseObject)
        self.dateInterval = jsonData["dt"].intValue
        super.init(responseObject)
    }
    
}
