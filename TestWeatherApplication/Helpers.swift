
import Foundation

let CurentWeatherCellId = "CurrentWeatherCell"
let ForecastWeatherCellId = "ForecastCell"
let AutocompleteCellId = "AutocompleteCell"

let PlaceViewControllerIdentifier = "PlaceViewController"
let AutocompleteViewControllerIdentifier = "AutocompleteViewController"
let PageViewControllerIdentifier = "PageViewController"

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
