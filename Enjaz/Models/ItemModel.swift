
import UIKit
import RealmSwift

class ItemModel: Object {
    @objc dynamic var id: Int = UUID().hashValue
    @objc dynamic var name: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var item_description: String = ""
    @objc dynamic var type: Int = 0
    @objc dynamic var status: Int = 0
    @objc dynamic var field_id: String = ""
    @objc dynamic var image_id: String = ""
    @objc dynamic var sticker_id: String = ""
}
