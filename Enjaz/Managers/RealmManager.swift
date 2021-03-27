
import UIKit
import RealmSwift

class RealmManager {
    
    static let realm = try! Realm()
    
    static var itemCategoriesCount: Int {
        return retrieveItemCategories().count
    }
    
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
    
    private static func retrieveGoals(withCompletedEqualTo completed: Bool) -> [ItemModel] {
        
        let completionFilter = "is_completed == \(completed.description)"
        let goals: [ItemModel] = RealmManager.realm.objects(ItemModel.self).filter(completionFilter).filter("type == 3").map({ $0 })
        return goals
    }
    
    static func retrieveCompletedGoals() -> [ItemModel] {
        return retrieveGoals(withCompletedEqualTo: true)
    }
    
    static func retrieveUpcomingGoals() -> [ItemModel] {
        return retrieveGoals(withCompletedEqualTo: false)
    }
    
    static func saveItemCategories(_ itemCategories: [ItemCategoryModel]) {
        RealmManager.realm.beginWrite()
        for itemCategory in itemCategories {
            RealmManager.realm.add(itemCategory)
        }
        try! RealmManager.realm.commitWrite()
    }
    
    static func saveItemCategory(_ itemCategory: ItemCategoryModel) {
        RealmManager.realm.beginWrite()
        RealmManager.realm.add(itemCategory)
        try! RealmManager.realm.commitWrite()
    }
    
    static func retrieveItemCategories() -> [ItemCategoryModel] {
        let itemCategories: [ItemCategoryModel] = RealmManager.realm.objects(ItemCategoryModel.self).map({ $0 })
        return itemCategories
    }
    
    static func retrieveItemCategoryById(_ id: Int) -> ItemCategoryModel? {
        let itemCategory = RealmManager.realm.object(ofType: ItemCategoryModel.self, forPrimaryKey: id)
        
        return itemCategory
    }
}
