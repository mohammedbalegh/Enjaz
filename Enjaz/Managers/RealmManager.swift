
import UIKit
import RealmSwift

struct RealmManager {
    
    static let realm = try! Realm()
    
    static var itemCategoriesCount: Int {
        return retrieveItemCategories().count
    }
	
	static var itemImagesCount: Int {
		return retrieveItemImages().count
	}
    
	static var personalAspectsCount: Int {
		return retrievePersonalAspects().count
	}
	
    static func itemMedalsCount(category: Int) -> Int {
        return retrieveItemMedals(category: category).count
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
	
	
	// MARK: ItemModel
	
	static func saveItem(_ item: ItemModel) {
		realm.beginWrite()
		realm.add(item)
		try? realm.commitWrite()
	}
	
	static func retrieveItemById(_ id: Int) -> ItemModel? {
		let item = realm.object(ofType: ItemModel.self, forPrimaryKey: id)
		return item
	}
	
    static func retrieveItems() -> [ItemModel] {
		let items: [ItemModel] = Array(realm.objects(ItemModel.self).sorted(byKeyPath: "date", ascending: true).sorted(byKeyPath: "is_pinned",ascending: false))
        return items
    }
        
    static func retrieveItems(withFilter filter: String) -> [ItemModel] {
        let items: [ItemModel] = Array(realm.objects(ItemModel.self).filter(filter).sorted(byKeyPath: "date", ascending: true).sorted(byKeyPath: "is_pinned",ascending: false))
        return items
    }
	
	static func retrieveItems(subsequentTo item: ItemModel) -> [ItemModel] {
		return retrieveItems(withFilter: "originalItemId == \(item.id)")
	}
    
    static func retrieveItemsBySearch(contains filter: String) -> [ItemModel] {
        let items: [ItemModel] = Array(realm.objects(ItemModel.self).filter("name contains[c] %@", filter).sorted(byKeyPath: "date", ascending: true).sorted(byKeyPath: "is_pinned",ascending: false))
        return items
    }
	
	static func completeItem(_ item: ItemModel, isCompleted: Bool) {
		realm.beginWrite()
		item.is_completed = isCompleted
		completeSubsequentItemsIfIncluded(item, isCompleted: isCompleted)
		try? realm.commitWrite()
	}
	
	private static func completeSubsequentItemsIfIncluded(_ item: ItemModel, isCompleted: Bool) {
		if item.is_repeated {
			let subsequentItems = retrieveItems(subsequentTo: item)
			subsequentItems.forEach { $0.is_completed = isCompleted }
		}
	}
	
	static func pinItem(_ item: ItemModel, isPinned: Bool) {
		realm.beginWrite()
		item.is_pinned = isPinned
		pinSubsequentItemsIfIncluded(item, isPinned: isPinned)
		try? realm.commitWrite()
	}
	
	private static func pinSubsequentItemsIfIncluded(_ item: ItemModel, isPinned: Bool) {
		if item.is_repeated {
			let subsequentItems = retrieveItems(subsequentTo: item)
			subsequentItems.forEach { $0.is_pinned = isPinned }
		}
	}
	
	static func deleteItems(withFilter filter: String) {
		realm.beginWrite()
		let items = retrieveItems(withFilter: filter)
		items.forEach { deleteItemInsideWritingTransaction($0) }
		try! realm.commitWrite()
	}
	
	static func deleteItem(_ item: ItemModel) {
		realm.beginWrite()
		deleteItemInsideWritingTransaction(item)
		try! realm.commitWrite()
	}
	
	private static func deleteItemInsideWritingTransaction(_ item: ItemModel) {
		deletePendingNotificationRequest(item)
		deleteSubsequentItemsIfIncluded(item)
		deleteAssociatedImageIfNeeded(item)
		
		realm.delete(realm.object(ofType: ItemModel.self, forPrimaryKey: item.id)!)
	}
		
	private static func deletePendingNotificationRequest(_ item: ItemModel) {
		if item.date > Date().timeIntervalSince1970 {
			NotificationsManager.removePendingNotificationRequests(withIdentifiers: [String(item.id)])
		}
	}
	
	private static func deleteSubsequentItemsIfIncluded(_ item: ItemModel) {
		if item.is_repeated {
			let subsequentItems = retrieveItems(subsequentTo: item)
			subsequentItems.forEach { deleteItemInsideWritingTransaction($0) }
		}
	}
	
	private static func deleteAssociatedImageIfNeeded(_ item: ItemModel) {
		if let image = retrieveItemImageById(item.image_id), !image.is_default {
			realm.delete(image)
		}
	}
	
	// MARK: ItemCategoryModel
    
    static func saveItemCategories(_ itemCategories: [ItemCategoryModel]) {
        realm.beginWrite()
        for itemCategory in itemCategories {
            realm.add(itemCategory)
        }
        try? realm.commitWrite()
    }
    
    static func saveItemCategory(_ itemCategory: ItemCategoryModel) {
		saveItemCategories([itemCategory])
    }
    
    static func deleteItemCategory(_ category: ItemCategoryModel) {
		realm.beginWrite()
		realm.delete(category)
		try? realm.commitWrite()
    }
	
	static func retrieveItemCategories() -> [ItemCategoryModel] {
		let itemCategories: [ItemCategoryModel] = Array(realm.objects(ItemCategoryModel.self))
		return itemCategories
	}
	
	static func retrieveItemCategoryById(_ id: Int) -> ItemCategoryModel? {
		let itemCategory = realm.object(ofType: ItemCategoryModel.self, forPrimaryKey: id)
		return itemCategory
	}
	
	
	// MARK: ItemImageModel
    
	static func saveItemImages(_ itemImages: [ItemImageModel]) {
		realm.beginWrite()
		for itemCategory in itemImages {
			realm.add(itemCategory)
		}
		try? realm.commitWrite()
	}
	
	static func saveItemImage(_ itemImage: ItemImageModel) {
		saveItemImages([itemImage])
	}
	
	static func retrieveItemImages(withFilter filter: String? = nil) -> [ItemImageModel] {
		let itemImages: [ItemImageModel] = {
			let allItemImages = realm.objects(ItemImageModel.self)
			if let filter = filter {
				return Array(allItemImages.filter(filter))
			}
			return Array(allItemImages)
		}()
		
		return itemImages
	}
	
	static func retrieveDefaultItemImages(withFilter filter: String? = nil) -> [ItemImageModel] {
		return retrieveItemImages(withFilter: "is_default == true && is_selectable == true")
	}
	
	static func retrieveItemImageById(_ id: Int) -> ItemImageModel? {
		let itemImage = realm.object(ofType: ItemImageModel.self, forPrimaryKey: id)
		return itemImage
	}
	
	static func retrieveItemImageSourceById(_ id: Int) -> String? {
		let itemImage = realm.object(ofType: ItemImageModel.self, forPrimaryKey: id)
		return itemImage?.image_source
	}
	
	static func deleteItemImage(_ itemImage: ItemImageModel) {
		realm.beginWrite()
		realm.delete(itemImage)
		try? realm.commitWrite()
	}
	
	
	// MARK: MedalModel
	
    static func saveItemMedal(_ itemMedal: MedalModel) {
        realm.beginWrite()
        realm.add(itemMedal)
        try? realm.commitWrite()
    }
	
	static func retrieveItemMedals(category: Int) -> [MedalModel] {
		let count = realm.objects(MedalModel.self).filter("category == \(category)").map({ $0 })
		return Array(count)
	}
	
	
	// MARK: PersonalAspectsModel
	
	static func saveAspect(_ aspect: PersonalAspectsModel) {
		realm.beginWrite()
		realm.add(aspect)
		try? realm.commitWrite()
	}
	
	static func retrievePersonalAspects() -> [PersonalAspectsModel] {
		let aspects: [PersonalAspectsModel] = Array(realm.objects(PersonalAspectsModel.self).sorted(byKeyPath: "date", ascending: true))
		return aspects
	}
	
	static func retrieveAspect(id: Int) -> PersonalAspectsModel {
		let items: PersonalAspectsModel = realm.object(ofType: PersonalAspectsModel.self, forPrimaryKey: id)!
		return items
	}
        
}
