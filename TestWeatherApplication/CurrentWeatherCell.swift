

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Kingfisher

class CurrentWeatherCell: UITableViewCell {
    
    private weak var viewModel: CurrentWeatherCellViewModel!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var visibility: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
