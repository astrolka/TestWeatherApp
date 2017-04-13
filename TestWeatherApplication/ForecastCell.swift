//
//  ForecastCell.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 12.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Kingfisher

class ForecastCell: UITableViewCell {
    
    private weak var viewModel: ForecastCellViewModel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
