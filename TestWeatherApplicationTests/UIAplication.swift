//
//  UIAplication.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 04.05.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

extension Reactive where Base: UIApplication {
    
    public var isNetworkIndicatorVisible: BindingTarget<Bool> {
        return makeBindingTarget { (app, newFlag) in
            if app.isNetworkActivityIndicatorVisible != newFlag {
                app.isNetworkActivityIndicatorVisible = newFlag
            }
        }
    }
    
}
