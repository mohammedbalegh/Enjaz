
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
        let count = Array(RealmManager.realm.objects(PersonalAspectsModel.self)).count
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
        let items: [ItemModel] = Array(RealmManager.realm.objects(ItemModel.self).sorted(byKeyPath: "date", ascending: true))
        return items
    }
    
    static func retrieveItems(withFilter filter: String) -> [ItemModel] {
        let items: [ItemModel] = Array(RealmManager.realm.objects(ItemModel.self).filter(filter).sorted(byKeyPath: "date", ascending: true))
        return items
    }
    
    static func retrievePersonalAspects() -> [PersonalAspectsModel] {
        let aspects: [PersonalAspectsModel] = Array(RealmManager.realm.objects(PersonalAspectsModel.self).sorted(byKeyPath: "date", ascending: true))
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
    
    private static func retrieveGoals(withCompletedEqualTo completed: Bool, andCategoryEqualTo category: ItemCategoryModel) -> [ItemModel] {
        
        let completionFilter = "is_completed == \(completed.description)"
        let goals: [ItemModel] = Array(RealmManager.realm.objects(ItemModel.self).filter("\(completionFilter) AND type == \(ItemType.goal.id) AND category == \(category.id)"))
        return goals
    }
    
    static func retrieveCompletedGoals(ofCategory category: ItemCategoryModel) -> [ItemModel] {
        return retrieveGoals(withCompletedEqualTo: true, andCategoryEqualTo: category)
    }
    
    static func retrieveUpcomingGoals(ofCategory category: ItemCategoryModel) -> [ItemModel] {
        return retrieveGoals(withCompletedEqualTo: false, andCategoryEqualTo: category)
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
    
    static func deleteItemCategory(categoryId: Int) {
        let allItemsRelatedToCategory = getAllItemsRelatedTo(categoryId: categoryId)
        if let itemCategoryToBeDeleted = RealmManager.retrieveItemCategoryById(categoryId) {
            RealmManager.realm.beginWrite()
            RealmManager.realm.delete(itemCategoryToBeDeleted)
            RealmManager.realm.delete(allItemsRelatedToCategory)
            try! RealmManager.realm.commitWrite()
        }
    }
    
    private static func getAllItemsRelatedTo(categoryId: Int) -> [ItemModel] {
        let itemsRelatedToCategory = retrieveItems(withFilter: "category == \(categoryId)")
        
        return itemsRelatedToCategory
    }
    
    static func saveItemMedal(_ itemMedal: MedalModel) {
        RealmManager.realm.beginWrite()
        RealmManager.realm.add(itemMedal)
        try! RealmManager.realm.commitWrite()
    }
    
    static func retrieveItemCategories() -> [ItemCategoryModel] {
        let itemCategories: [ItemCategoryModel] = Array(RealmManager.realm.objects(ItemCategoryModel.self))
        return itemCategories
    }
    
    static func retrieveItemCategoryById(_ id: Int) -> ItemCategoryModel? {
        let itemCategory = RealmManager.realm.object(ofType: ItemCategoryModel.self, forPrimaryKey: id)
        
        return itemCategory
    }
}
