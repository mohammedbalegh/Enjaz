import RealmSwift

class MedalModel: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var medalDescription: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var earned: Bool = false
    
    override init() { }
    
    init(id: Int? = nil, name: String, category: String, image_source: String, earned: Bool) {
        if let id = id {
            self.id = id
        }
        self.name = name
        self.medalDescription = category
        self.image = image_source
        self.earned = earned
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
        case medalDescription = "description"    
    }
    
}
