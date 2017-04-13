//
//  Helpers.swift
//  TestWeatherApplication
//
//  Created by Александр Смоленский on 13.04.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation

class ResultModels<T: ServerModelProtocol> {
    let results: [T]
    
    init(response: [[String : Any]]) {
        results = response.map({ (dict) -> T in
            return T(dict)
        })
    }
    
}

protocol ServerModelProtocol {
    init(_ response: [String : Any])
}
