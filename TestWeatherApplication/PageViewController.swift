

import UIKit
import ReactiveCocoa
import ReactiveSwift

class PageViewController: UIPageViewController {
    
    
    private var currentIndex = 0
    fileprivate var transitionInProgress = false
    private var viewModel: PageViewModel!
    fileprivate var orderedViewControllers: [PlaceViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let vc = orderedViewControllers.first {
            setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
        dataSource = self
        delegate = self
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func bindViewModel(_ viewModel: PageViewModel) {
        self.viewModel = viewModel
        
        orderedViewControllers = viewModel.pageViewModels.map({ (placeViewModel) -> PlaceViewController in
            let vc = storyboard?.instantiateViewController(withIdentifier: PlaceViewControllerIdentifier) as! PlaceViewController
            vc.viewModel = placeViewModel
            return vc
        })
        
        viewModel.insertPlaceSignal.observeValues { [weak self] (placeViewModel) in
            if self?.transitionInProgress ?? true {
                return
            }
            
            self?.transitionInProgress = true
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: PlaceViewControllerIdentifier) as! PlaceViewController
            vc.viewModel = placeViewModel
            self?.orderedViewControllers.append(vc)
            self?.setViewControllers([vc], direction: .forward, animated: true) { (finished) in
                self?.transitionInProgress = !finished
            }
            
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
        
        if currentIndex == 0 || transitionInProgress {
            return nil
        }
        
        return orderedViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = orderedViewControllers.index(of: viewController as! PlaceViewController) else {
            return nil
        }
        
        if currentIndex >= orderedViewControllers.count - 1 || transitionInProgress {
            return nil
        }
        return orderedViewControllers[currentIndex + 1]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        transitionInProgress = true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        transitionInProgress = !finished
    }
}





