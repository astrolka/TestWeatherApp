

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
