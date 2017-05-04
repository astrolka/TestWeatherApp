

import Foundation
import SwiftyJSON

class PhotoModel {
    let farm: Int?
    let id: String?
    let server: String?
    let secret: String?
    let owner: String?
    
    init(dictionary: [String : Any]) {
        let jsonObject = JSON(dictionary)
        let firstPhoto = jsonObject["photos"]["photo"][0]
        self.farm = firstPhoto["farm"].int
        self.id = firstPhoto["id"].string
        self.server = firstPhoto["server"].string
        self.secret = firstPhoto["secret"].string
        self.owner = firstPhoto["owner"].string
    }
}
