
import UIKit
import RealmSwift

class RealmManager {
    
    static let realm = try! Realm()
    
    static func saveItem(_ item: ItemModel) {
        RealmManager.realm.beginWrite()
        RealmManager.realm.add(item)
        try! RealmManager.realm.commitWrite()
    }
    
    static func retrieveItems() -> [ItemModel] {
        let items: [ItemModel] = RealmManager.realm.objects(ItemModel.self).map({ $0 })
        return items
    }
    
    static func dropModelTable(_ model: Object.Type) {
        try? realm.write {
            let table = realm.objects(model)
            realm.delete(table)
        }
    }
    
    static func removeAllTables() {
        try? realm.write {
            realm.deleteAll()
        }
    }
    
}
