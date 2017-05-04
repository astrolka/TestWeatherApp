

import Foundation
import SwiftyJSON

class CommonWeatherModel {
    var temperature: Double?
    var pressure: Double?
    var humidity: Int?
    var windSpeed: Double?
    var icon: String?
    var info: String?
    
    init(_ responseObject: [String : Any]) {
        let jsonData = JSON(responseObject)
        self.temperature = jsonData["main"]["temp"].double
        self.pressure = jsonData["main"]["pressure"].double
        self.humidity = jsonData["main"]["humidity"].int
        self.windSpeed = jsonData["wind"]["speed"].double
        self.icon = jsonData["weather"][0]["icon"].string
        self.info = jsonData["weather"][0]["description"].string
    }
    
}

class CurrentWeatherModel: CommonWeatherModel {
    
    var visibility: Int?
    
    override init(_ responseObject: [String : Any]) {
        let jsonData = JSON(responseObject)
        self.visibility = jsonData["visibility"].int
        super.init(responseObject)
    }
}

class ForecastWeatherModel: CommonWeatherModel, ServerModel {
    var dateInterval: Int?
    
    override required init(_ responseObject: [String : Any]) {
        let jsonData = JSON(responseObject)
        self.dateInterval = jsonData["dt"].int
        super.init(responseObject)
    }
    
}
