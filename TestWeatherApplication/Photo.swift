

import Foundation
import RealmSwift

class Photo: Object {
    dynamic var farm: Int = 0
    dynamic var id: Int = 0
    dynamic var server: Int = 0
    dynamic var secret: String = ""
    dynamic var owner: String = ""
    
    func bindServerModel(_ model: PhotoModel) {
        self.farm = model.farm
        self.id = model.id
        self.server = model.server
        self.secret = model.secret
        self.owner = model.owner
    }
    
}
