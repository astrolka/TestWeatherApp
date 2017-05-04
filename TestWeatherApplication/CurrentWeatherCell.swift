

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Kingfisher

class CurrentWeatherCell: UITableViewCell {
    
    private weak var viewModel: CurrentWeatherCellViewModel!
    
    @IBOutlet private weak var city: UILabel!
    @IBOutlet private weak var country: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    @IBOutlet private weak var info: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var windSpeed: UILabel!
    @IBOutlet private weak var visibility: UILabel!
    
    func bindViewModel(_ viewModel: CurrentWeatherCellViewModel) {
        self.viewModel = viewModel
        city.text = viewModel.city
        country.text = viewModel.country
        temperature.reactive.text <~ viewModel.temperature
        info.reactive.text <~ viewModel.info
        pressure.reactive.text <~ viewModel.pressure
        humidity.reactive.text <~ viewModel.humidity
        windSpeed.reactive.text <~ viewModel.windSpeed
        visibility.reactive.text <~ viewModel.visibility
        icon.reactive.url <~ viewModel.iconUrl
    }

}
