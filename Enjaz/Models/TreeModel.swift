import RealmSwift

class TreeModel: Object {
    @objc dynamic var id: Int = 0
    var stages = List<TreeStageModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
