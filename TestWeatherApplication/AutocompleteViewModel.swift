

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

class AutocompleteViewModel {
    
    var cellViewModels: [CityViewModel]?
    let reloadTableView = MutableProperty<Bool>(false)
    let (addNewLocationSignal, addNewLocationObserver) = Signal<IndexPath, NoError>.pipe()
    var textSignal: Signal<String?, NoError>? = nil {
        didSet {
            setupTextFieldSignal()
        }
    }
    
    private let sourceViewModel: PageViewModel
    private var searchSignalProducer: SignalProducer<ResultModels<CityModel>, WeatherAppError>?
    
    init(sourceViewModel: PageViewModel) {
        self.sourceViewModel = sourceViewModel
        addNewLocationSignal.observeValues { [weak self] (indexPath) in
            let cityModel = self?.cellViewModels?[indexPath.row].cityModel
            if let cityModel = cityModel, let weakSelf = self, ViewModelManager.shared.isValidNew(city: cityModel) {
                let location = ViewModelManager.shared.placeForCityModel(cityModel)
                self?.sourceViewModel.insertPlaceObserver.send(value: PlaceViewModel(place: location, pageViewModel: weakSelf.sourceViewModel))
            }
        }
    }
    
    func setupTextFieldSignal() {
        _ = textSignal?.throttle(0.4, on: QueueScheduler.main).observeValues { [weak self] text in
            guard let text = text else {
                return
            }
            self?.searchSignalProducer = ViewModelManager.shared.getSugestionsForText(text)
            self?.searchSignalProducer?.startWithResult { (result) in
                switch result {
                case .success(let resultModels):
                    self?.cellViewModels = resultModels.results.map({ (cityModel) -> CityViewModel in
                        return CityViewModel(model: cityModel)
                    })
                    self?.reloadTableView.value = true
                case .failure(let error):
                    //show smth to user, in next version (:
                    print(error)
                }
            }
        }
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if let viewModels = cellViewModels, section == 0 {
            return viewModels.count
        }
        return 0
    }
    
    func cellViewModelForIndexPath(_ indexPath: IndexPath) -> CityViewModel? {
        if let viewModels = cellViewModels {
            return viewModels[indexPath.row]
        }
        return nil
    }
}
