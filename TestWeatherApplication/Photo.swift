

import Foundation
import RealmSwift

class Photo: Object {
    dynamic var farm: Int = 0
    dynamic var id: String = ""
    dynamic var server: String = ""
    dynamic var secret: String = ""
    dynamic var owner: String = ""
    
    func bindServerModel(_ model: PhotoModel) {
        guard let farm = model.farm, let id = model.id, let server = model.server, let secret = model.secret, let owner = model.owner else {
            return
        }
        self.farm = farm
        self.id = id
        self.server = server
        self.secret = secret
        self.owner = owner
    }
    
}
