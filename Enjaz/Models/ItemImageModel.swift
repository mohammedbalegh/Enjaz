import RealmSwift

class ItemImageModel: Object {
	@objc dynamic var id = UUID().hashValue
	@objc dynamic var image_source = ""
	@objc dynamic var is_default = false
	@objc dynamic var is_selectable = true
		
	override init() { }
	
	init(id: Int? = nil, imageSource: String, isDefault: Bool, isSelectable: Bool) {
		if let id = id {
			self.id = id
		}
		image_source = imageSource
		is_default = isDefault
		is_selectable = isSelectable
	}
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
