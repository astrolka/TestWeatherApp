

import Foundation
import ReactiveSwift

class CommonWeatherCellViewModel {
    
    let temperature = MutableProperty<String>("")
    let iconUrl = MutableProperty<URL?>(nil)
    let info = MutableProperty<String>("")
    let pressure = MutableProperty<String>("")
    let humidity = MutableProperty<String>("")
    let windSpeed = MutableProperty<String>("")
    
    fileprivate weak var model: CommonWeather?
    
    init(model: CommonWeather) {
        self.model = model
    }
    
    func updateViewModel(model: CommonWeather) {
        self.model = model
        temperature.value = "\(Int(model.temperature))°"
        iconUrl.value = URL(string: "http://openweathermap.org/img/w/\(model.icon).png")!
        info.value = model.info
        pressure.value = "\(Int(model.pressure * 0.75006375541921)) mmHg"
        humidity.value = "\(model.humidity) %"
        windSpeed.value = "\(model.windSpeed) m/s"
    }
    
}

class CurrentWeatherCellViewModel: CommonWeatherCellViewModel {
    
    let visibility = MutableProperty<String>("")
    let city: String
    let country: String
    
    init(model: Place) {
        city = model.cityName
        country = model.countryName
        super.init(model: model.currentWeather!)
        updateViewModel(model: model.currentWeather!)
    }
    
    func updateViewModel(model: CurrentWeather) {
        super.updateViewModel(model: model)
        
        if model.visibility >= 1000 {
            visibility.value = String(format: "%.1f", Double(model.visibility) / 1000.0) + " km"
        } else {
            visibility.value = "\(model.visibility) m"
        }
        
    }
    
}

class ForecastCellViewModel: CommonWeatherCellViewModel {
    
    let date = MutableProperty<String>("")
    let time = MutableProperty<String>("")
    
    
    init(model: ForecastWeather) {
        super.init(model: model)
        updateViewModel(model: model)
    }
    
    func updateViewModel(model: ForecastWeather) {
        super.updateViewModel(model: model)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let date = Date(timeIntervalSince1970: TimeInterval(model.dateInterval))
        self.date.value = formatter.string(from: date)
        formatter.dateFormat = "HH:mm"
        time.value = formatter.string(from: date)
    }
    
}
