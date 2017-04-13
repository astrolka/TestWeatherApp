//
//  ReactiveKingfisherExtention.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 13.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//
import Foundation
import ReactiveSwift
import Kingfisher
import UIKit

extension Reactive where Base: UIImageView {
    public var url: BindingTarget<URL?> {
        return makeBindingTarget { $0.kf.setImage(with: $1)}
    }
}
