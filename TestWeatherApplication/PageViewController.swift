

import UIKit
import ReactiveCocoa
import ReactiveSwift

class PageViewController: UIPageViewController {
    
    
    private var currentIndex = 0
    private var viewModel: PageViewModel!
    fileprivate var orderedViewControllers: [PlaceViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let vc = orderedViewControllers.first {
            setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
        dataSource = self
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func bindViewModel(_ viewModel: PageViewModel) {
        self.viewModel = viewModel
        
        orderedViewControllers = viewModel.pageViewModels.map({ (placeViewModel) -> PlaceViewController in
            let placeViewController = storyboard?.instantiateViewController(withIdentifier: "PlaceViewController") as! PlaceViewController
            placeViewController.bindViewModel(placeViewModel)
            return placeViewController
        })
        
        viewModel.insertPlaceSignal.observeValues { [weak self] (placeViewModel) in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PlaceViewController") as! PlaceViewController
            vc.bindViewModel(placeViewModel)
            self?.orderedViewControllers.append(vc)
            self?.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            DispatchQueue.main.async {
                self?.dataSource = nil
                self?.dataSource = self
            }
        }
        
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = orderedViewControllers.index(of: viewController as! PlaceViewController) else {
            return nil
        }
        
        if currentIndex == 0 {
            return nil
        }
        
        return orderedViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = orderedViewControllers.index(of: viewController as! PlaceViewController) else {
            return nil
        }
        
        if currentIndex >= orderedViewControllers.count - 1 {
            return nil
        }
        return orderedViewControllers[currentIndex + 1]
    }
}




