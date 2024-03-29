import RealmSwift

class ItemCategoryModel: Object, Decodable {
    @objc dynamic var id = UUID().hashValue
    @objc dynamic var name = ""
    @objc dynamic var category_description: String = ""
    @objc dynamic var image_source = ""
    @objc dynamic var is_default = false
    
    @objc dynamic var localized_name: String {
        if is_default {
            return name.localized
        }
        
        return name
    }
    
    @objc dynamic var localized_description: String {
        if is_default {
            return category_description.localized
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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image_source = "image"
        case category_description = "description"
    }
}
