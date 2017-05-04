

import Foundation
import RealmSwift

class CommonWeather: Object {
    dynamic var temperature: Double = 0
    dynamic var pressure: Double = 0
    dynamic var humidity: Int = 0
    dynamic var windSpeed: Double = 0
    dynamic var icon: String = ""
    dynamic var info: String = ""

    fileprivate func bindServerModel(_ model: CommonWeatherModel) {
        self.temperature = model.temperature ?? 0
        self.pressure = model.pressure ?? 0
        self.humidity = model.humidity ?? 0
        self.windSpeed = model.windSpeed ?? 0
        self.icon = model.icon ?? ""
        self.info = model.info ?? ""
    }
}

class CurrentWeather: CommonWeather {
    dynamic var visibility: Int = 0
    
    func bindServerModel(_ model: CurrentWeatherModel) {
        self.visibility = model.visibility ?? 0
        super.bindServerModel(model)
    }
    
}

class ForecastWeather: CommonWeather {
    dynamic var dateInterval: Int = 0
    
    func bindServerModel(_ model: ForecastWeatherModel) {
        self.dateInterval = model.dateInterval ?? 0
        super.bindServerModel(model)
    }
    
}
