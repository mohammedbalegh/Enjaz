import RealmSwift

class MedalModel: Object {
    @objc dynamic var id: Int = UUID().hashValue
    @objc dynamic var name: String = ""
    @objc dynamic var category: Int = 0
    @objc dynamic var image_source: String = ""
    
    override init() { }
    
    init(id: Int? = nil, name: String, category: Int, image_source: String) {
        if let id = id {
            self.id = id
        }
        self.name = name
        self.category = category
        self.image_source = image_source
    }
    
}
