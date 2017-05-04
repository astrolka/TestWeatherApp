

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Kingfisher

class ForecastCell: UITableViewCell {
    
    private weak var viewModel: ForecastCellViewModel!
    
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var info: UILabel!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var windSpeed: UILabel!
    
    func bindViewModel(_ viewModel: ForecastCellViewModel) {
        self.viewModel = viewModel
        date.reactive.text <~ viewModel.date
        time.reactive.text <~ viewModel.time
        temperature.reactive.text <~ viewModel.temperature
        info.reactive.text <~ viewModel.info
        pressure.reactive.text <~ viewModel.pressure
        humidity.reactive.text <~ viewModel.humidity
        windSpeed.reactive.text <~ viewModel.windSpeed
        icon.reactive.url <~ viewModel.iconUrl
    }

}
