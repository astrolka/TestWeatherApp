//
//  UITableView.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 13.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

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
