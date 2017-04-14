

import Foundation
import RealmSwift
import ReactiveSwift
import ReactiveCocoa
import Result

enum Action {
    case Delete, AddNew
}

class PlaceViewModel {
    
    //MARK: - Properties
    
    let (insertSignal, insertObserver) = Signal<[IndexPath], NoError>.pipe()
    let (deleteSignal, deleteObserver) = Signal<[IndexPath], NoError>.pipe()
    let (reloadSignal, reloadObserver) = Signal<[IndexPath], NoError>.pipe()
    let (refreshSignal, refreshObserver) = Signal<Any?, NoError>.pipe()
    let imgUrl = MutableProperty<URL?>(nil)
    
    
    
    private let place: Place
    private weak var pageViewModel: PageViewModel?
    private var forecastViewModels = [ForecastCellViewModel]()
    private var currentWeatherViewModel: CurrentWeatherCellViewModel!
    private var forecastNotificationToken: NotificationToken?
    private var placeNotificationToken: NotificationToken?
    
    //MARK: - Initialization
    
    init(place: Place, pageViewModel: PageViewModel) {
        self.place = place
        self.pageViewModel = pageViewModel
        setupCellViewModels()
        setupPlaceNotifications()
        setupForecastNotifications()
        setupObservers()
        performRefresh()
    }
    
    private func setupObservers() {
        refreshSignal.observeValues { [weak self] (state) in
            self?.performRefresh()
        }
    }
    
    private func setupPlaceNotifications() {
        placeNotificationToken = place.addNotificationBlock({ [weak self] (change) in
            switch change {
            case .change(let parameters):
                let currentWeatherParameter = parameters.filter({ (property) -> Bool in
                    return property.name == "currentWeather"
                })
                let photos = parameters.filter({ (property) -> Bool in
                    return property.name == "photo"
                })
                if currentWeatherParameter.first != nil {
                    self?.setupFirstSectionCells()
                }
                if photos.first != nil {
                    self?.setupPhoto()
                }
            default:
                break
            }
        })
    }
    
    private func setupForecastNotifications() {
        forecastNotificationToken = place.forecast.addNotificationBlock { [weak self] (changes) in
            switch changes {
            case .update(_, let deletions, let insertions, let modifications):
                self?.performChanges(modifications, inserted: insertions, deleted: deletions)
            default:
                break
            }
        }
    }
    
    deinit {
        placeNotificationToken?.stop()
        forecastNotificationToken?.stop()
    }
    
    private func setupPhoto() {
        if let photo = place.photo {
            let stringUrl = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
            imgUrl.value = URL(string: stringUrl)
        }
    }
    
    private func setupFirstSectionCells() {
        if place.currentWeather != nil {
            if currentWeatherViewModel != nil {
                currentWeatherViewModel = CurrentWeatherCellViewModel(model: place, placeViewModel: self)
                reloadObserver.send(value: [IndexPath(row: 0, section: 0)])
            } else {
                currentWeatherViewModel = CurrentWeatherCellViewModel(model: place, placeViewModel: self)
                insertObserver.send(value: [IndexPath(row: 0, section: 0)])
            }
            
        }
    }
    
    private func setupCellViewModels() {
        setupFirstSectionCells()
        for forecastModel in place.forecast {
            let forecastCellViewModel = ForecastCellViewModel(model: forecastModel, placeViewModel: self)
            forecastViewModels.append(forecastCellViewModel)
        }
        setupPhoto()
    }
    
    private func performChanges(_ reloaded:[Int], inserted:[Int], deleted: [Int]) {
        for i in reloaded {
            if i < forecastViewModels.count {
                forecastViewModels[i].updateViewModel(model: place.forecast[i])
            }
        }
        for i in inserted {
            let forecastCellViewModel = ForecastCellViewModel(model: place.forecast[i], placeViewModel: self)
            if i < forecastViewModels.count {
                forecastViewModels.insert(forecastCellViewModel, at: i)
            } else {
                forecastViewModels.append(forecastCellViewModel)
            }
            
            
        }
        for i in deleted {
            if i < forecastViewModels.count {
                forecastViewModels.remove(at: i)
            }
        }
        insertObserver.send(value: makeIndexPathsFromIndexes(inserted))
        deleteObserver.send(value: makeIndexPathsFromIndexes(deleted))
        reloadObserver.send(value: makeIndexPathsFromIndexes(reloaded))
    }
    
    private func makeIndexPathsFromIndexes(_ indexes: [Int]) -> [IndexPath] {
        return indexes.map({ (index) -> IndexPath in
            return IndexPath(row: index, section: 1)
        })
    }
    
    private func performRefresh() {
        ViewModelManager.shared.updateDataForPlace(place).startWithResult { (result) in
            switch result {
            case .success: break
            //stop activity indicator
            case .failure(let error):
                //show overlay
                print(error)
            }
        }
    }
    
    //MARK: - Public methods
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfCellsIn(section: Int) -> Int {
        if section == 0 {
            return currentWeatherViewModel != nil ? 1 : 0
        } else {
            return forecastViewModels.count
        }
        
    }
    
    func cellViewModelFor(indexPath: IndexPath) -> CommonWeatherCellViewModel {
        if indexPath.section == 0 {
            return currentWeatherViewModel
        } else {
            return forecastViewModels[indexPath.row]
        }
    }
    
    func viewModelForAutoCompleteView() -> AutocompleteViewModel? {
        if let pageViewModel = pageViewModel {
            return AutocompleteViewModel(sourceViewModel: pageViewModel)
        } else {
            return nil
        }
        
    }
    
}
