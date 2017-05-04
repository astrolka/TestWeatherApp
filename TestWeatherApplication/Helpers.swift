
import Foundation

let CurentWeatherCellId = "CurrentWeatherCell"
let ForecastWeatherCellId = "ForecastCell"
let PlaceViewControllerIdentifier = "PlaceViewController"

protocol WeatherAppErrorProtocol: Error {
    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var code: Int { get }
}

class WeatherAppError: WeatherAppErrorProtocol {
    
    var localizedTitle: String
    var localizedDescription: String
    var code: Int
    
    init(localizedTitle: String?, localizedDescription: String, code: Int) {
        self.localizedTitle = localizedTitle ?? "Error"
        self.localizedDescription = localizedDescription
        self.code = code
    }
}
