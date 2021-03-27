import Foundation
class AppDataInitializer {
    static func initializeItemCategories() {
        let itemCategoriesAreEmpty = RealmManager.itemCategoriesCount == 0
        guard itemCategoriesAreEmpty else { return }
        
        RealmManager.saveItemCategories(DEFAULT_ITEM_CATEGORIES)
    }
}
