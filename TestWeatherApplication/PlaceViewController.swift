

import UIKit
import Kingfisher
import ReactiveSwift
import ReactiveCocoa

class PlaceViewController: UIViewController {
    
    fileprivate var viewModel: PlaceViewModel!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        let imageView = UIImageView()
        imageView.reactive.url <~ viewModel.imgUrl
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
    }
    
    func bindViewModel(_ viewModel: PlaceViewModel) {
        self.viewModel = viewModel
        
        viewModel.insertSignal
            .filter({ [weak self] (indexPaths) -> Bool in
                return indexPaths.count > 0 && self?.tableView != nil
            })
            .observeValues { [weak self] (indexPaths) in
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: indexPaths, with: .left)
                self?.tableView.endUpdates()
        }
        viewModel.deleteSignal
            .filter({ [weak self] (indexPaths) -> Bool in
                return indexPaths.count > 0 && self?.tableView != nil
            })
            .observeValues { [weak self] (indexPaths) in
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: indexPaths, with: .right)
                self?.tableView.endUpdates()
        }
        viewModel.reloadSignal
            .filter({ [weak self] (indexPaths) -> Bool in
                return indexPaths.count > 0 && self?.tableView != nil
            })
            .observeValues { [weak self] (indexPaths) in
                self?.tableView.beginUpdates()
                self?.tableView.reloadRows(at: indexPaths, with: .fade)
                self?.tableView.endUpdates()
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Add new location", style: .default) { [weak self] (action) in
            if let viewModel = self?.viewModel.viewModelForAutoCompleteView() {
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "AutocompleteViewController") as! AutocompleteViewController
                vc.bindViewModel(viewModel)
                self?.present(vc, animated: true, completion: nil)
            }
        }
        alertController.addAction(addAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        viewModel.refreshObserver.send(value: nil)
    }
    
    
}

extension PlaceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCellsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModel.cellViewModelFor(indexPath: indexPath)
        switch vm {
        case is CurrentWeatherCellViewModel:
            let currentWeatherCell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCell
            currentWeatherCell.bindViewModel(vm as! CurrentWeatherCellViewModel)
            return currentWeatherCell
        case is ForecastCellViewModel:
            let forecastWeatherCell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
            forecastWeatherCell.bindViewModel(vm as! ForecastCellViewModel)
            return forecastWeatherCell
        default:
            return UITableViewCell()
        }
        
    }
}
