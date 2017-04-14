

import Foundation
import SwiftyJSON

class PhotoModel {
    let farm: Int
    let id: Int
    let server: Int
    let secret: String
    let owner: String
    
    init(dictionary: [String : Any]) {
        let jsonObject = JSON(dictionary)
        self.farm = jsonObject["photos"]["photo"][0]["farm"].intValue
        self.id = jsonObject["photos"]["photo"][0]["id"].intValue
        self.server = jsonObject["photos"]["photo"][0]["server"].intValue
        self.secret = jsonObject["photos"]["photo"][0]["secret"].stringValue
        self.owner = jsonObject["photos"]["photo"][0]["owner"].stringValue
    }
}
