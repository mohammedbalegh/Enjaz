import RealmSwift

class ItemCategoryModel: Object {
    @objc dynamic var id = UUID().hashValue
    @objc dynamic var name = ""
    @objc dynamic var category_description: String = ""
    @objc dynamic var image_source = ""
    @objc dynamic var is_default = false
    
    @objc dynamic var localized_name: String {
        if is_default {
            return NSLocalizedString(name, comment: "")
        }
        
        return name
    }
    
    @objc dynamic var localized_description: String {
        if is_default {
            return NSLocalizedString(category_description, comment: "")
        }
        
        return category_description
    }
    
    override init() { }
    
    init(id: Int? = nil, name: String, category_description: String, imageSource: String, isDefault: Bool) {
        if let id = id {
            self.id = id
        }
        self.name = name
        self.category_description = category_description
        self.image_source = imageSource
        self.is_default = isDefault
    }
    
    override class func primaryKey() -> String? {
            return "id"
    }
}
