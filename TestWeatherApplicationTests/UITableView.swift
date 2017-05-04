
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
    
    public var insert: BindingTarget<[IndexPath]> {
        return makeBindingTarget { (tableView, indexPaths) in
            tableView.beginUpdates()
            tableView.insertRows(at: indexPaths, with: .left)
            tableView.endUpdates()
        }
    }
    
    public var delete: BindingTarget<[IndexPath]> {
        return makeBindingTarget { (tableView, indexPaths) in
            tableView.beginUpdates()
            tableView.deleteRows(at: indexPaths, with: .right)
            tableView.endUpdates()
        }
    }
    
    public var update: BindingTarget<[IndexPath]> {
        return makeBindingTarget { (tableView, indexPaths) in
            tableView.beginUpdates()
            tableView.reloadRows(at: indexPaths, with: .fade)
            tableView.endUpdates()
        }
    }
    
}
