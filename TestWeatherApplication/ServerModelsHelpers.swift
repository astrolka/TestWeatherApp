

import Foundation

class ResultModels<T: ServerModel> {
    let results: [T]
    
    init(response: [[String : Any]]) {
        results = response.map({ (dict) -> T in
            return T(dict)
        })
    }
    
}

protocol ServerModel {
    init(_ response: [String : Any])
}
