import RealmSwift

class ItemImageModel: Object {
	@objc dynamic var id = UUID().hashValue
	@objc dynamic var image_source = ""
	@objc dynamic var is_default = false
		
	override init() { }
	
	init(id: Int? = nil, imageSource: String, isDefault: Bool) {
		if let id = id {
			self.id = id
		}
		self.image_source = imageSource
		self.is_default = isDefault
	}
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
