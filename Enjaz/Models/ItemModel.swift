import RealmSwift

class ItemModel: Object {
    @objc dynamic var id: Int = UUID().hashValue
    @objc dynamic var name: String = ""
    @objc dynamic var date: Double = 0
    @objc dynamic var endDate: Double = 0
    @objc dynamic var item_description: String = ""
    @objc dynamic var category: Int = 0
    @objc dynamic var type: Int = 0
    @objc dynamic var is_completed: Bool = false
    @objc dynamic var image_id: Int = 0
    @objc dynamic var sticker_id: Int = 0
    @objc dynamic var originalItemId: Int = -1
    
    @objc dynamic var isOriginal: Bool { originalItemId == -1 }
    @objc dynamic var isRepeated: Bool { endDate != 0 }
}
