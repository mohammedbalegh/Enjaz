
import UIKit
import RealmSwift

class RealmManager {
    
    static let realm = try! Realm()
    
    static var itemCategoriesCount: Int {
        return retrieveItemCategories().count
    }
    
    static func itemMedalsCount(category: Int) -> Int {
        return retrieveItemMedals(category: category).count
    }
    
    static func saveItem(_ item: ItemModel) {
        RealmManager.realm.beginWrite()
        RealmManager.realm.add(item)
        try! RealmManager.realm.commitWrite()
    }
    
    static func saveAspect(_ aspect: PersonalAspectsModel) {
        RealmManager.realm.beginWrite()
        RealmManager.realm.add(aspect)
        try! RealmManager.realm.commitWrite()
    }
    
    static func retrieveAspectsCount() -> Int {
        let count = RealmManager.realm.objects(PersonalAspectsModel.self).map({ $0 }).count
        return count
    }
    
    static func retrieveItemMedals(category: Int) -> [MedalModel] {
        let count = RealmManager.realm.objects(MedalModel.self).filter("category == \(category)").map({ $0 })
        return Array(count)
    }
    
    static func retrieveAspect(id: Int) -> PersonalAspectsModel {
        let items: PersonalAspectsModel = RealmManager.realm.object(ofType: PersonalAspectsModel.self, forPrimaryKey: id)!
        return items
    }
    
    static func retrieveItems() -> [ItemModel] {
        let items: [ItemModel] = RealmManager.realm.objects(ItemModel.self).map({ $0 })
        return items
    }
    
    static func retrievePersonalAspects() -> [PersonalAspectsModel] {
        let aspects: [PersonalAspectsModel] = RealmManager.realm.objects(PersonalAspectsModel.self).sorted(byKeyPath: "date", ascending: true).map({ $0 })
        return aspects
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
    
    static func saveItemMedal(_ itemMedal: MedalModel) {
        RealmManager.realm.beginWrite()
        RealmManager.realm.add(itemMedal)
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
