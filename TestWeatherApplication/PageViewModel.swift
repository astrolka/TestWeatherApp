
import Foundation
import ReactiveSwift
import Result

class PageViewModel {
    var pageViewModels = [PlaceViewModel]()
    let (insertPlaceSignal, insertPlaceObserver) = Signal<PlaceViewModel, NoError>.pipe()

    init() {
        let models = ViewModelManager.shared.getPlaces()
        
        pageViewModels = models.map({ (place) -> PlaceViewModel in
            return PlaceViewModel(place: place, pageViewModel: self)
        })
        
        ViewModelManager.shared.placeChangedSignal()
        .filter({ (cityModel) -> Bool in
            return ViewModelManager.shared.isValidNew(city: cityModel)
        }).observeValues { [weak self] (cityModel) in
            let place = ViewModelManager.shared.placeForCityModel(cityModel)
            if self != nil {
                self?.insertPlaceObserver.send(value: PlaceViewModel(place: place, pageViewModel: self!))
            }
        }
    }
}
