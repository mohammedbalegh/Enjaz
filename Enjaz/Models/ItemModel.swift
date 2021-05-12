import RealmSwift

class ItemModel: Object {
    @objc dynamic var id: Int = UUID().hashValue
    @objc dynamic var name: String = ""
    @objc dynamic var date: Double = 0
    @objc dynamic var end_date: Double = 0
    @objc dynamic var item_description: String = ""
    @objc dynamic var category_id: Int = 0
    @objc dynamic var type_id: Int = 0
    @objc dynamic var is_completed: Bool = false
	@objc dynamic var is_pinned: Bool = false
    @objc dynamic var image_id: Int = 0
    @objc dynamic var original_item_id: Int = -1
    
    @objc dynamic var is_original: Bool { original_item_id == -1 }
    @objc dynamic var is_repeated: Bool { end_date != 0 }
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
