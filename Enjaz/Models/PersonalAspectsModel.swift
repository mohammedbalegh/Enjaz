import RealmSwift

class PersonalAspectsModel: Object {
    @objc dynamic var id: Int = UUID().hashValue
    @objc dynamic var title: String = ""
    @objc dynamic var briefOrDate: String? = ""
    @objc dynamic var date = Date()
    let category = RealmOptional<Int>()
    @objc dynamic var image: String = ""
    @objc dynamic var badge: String = ""
    @objc dynamic var aspect_description: String? = nil
    @objc dynamic var aspect_text: String? = NSLocalizedString("Write what you know about your self", comment:"")
    
    override class func primaryKey() -> String? {
           return "id"
       }
}
