
import Foundation
import ReactiveSwift
import UIKit

extension Reactive where Base: UITableView {
    
    public var shouldReload: BindingTarget<Bool> {
        return makeBindingTarget {
            if $1 {
                $0.reloadData()
            }
        }
    }
    
}
