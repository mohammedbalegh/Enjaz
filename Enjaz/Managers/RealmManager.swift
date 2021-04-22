
import UIKit
import RealmSwift

class RealmManager {
    
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
		try! realm.commitWrite()
	}
	
    static func retrieveItems() -> [ItemModel] {
        let items: [ItemModel] = Array(realm.objects(ItemModel.self).sorted(byKeyPath: "date", ascending: true))
        return items
    }
    
    static func retrieveItemById(_ id: Int) -> ItemModel? {
        let item = realm.object(ofType: ItemModel.self, forPrimaryKey: id)
        return item
    }
    
    static func retrieveItems(withFilter filter: String) -> [ItemModel] {
        let items: [ItemModel] = Array(realm.objects(ItemModel.self).filter(filter).sorted(byKeyPath: "date", ascending: true))
        return items
    }
    
    static func retrieveItemsBySearch(contains filter: String) -> [ItemModel] {
        let items: [ItemModel] = Array(realm.objects(ItemModel.self).filter("name contains[c] %@", filter).sorted(byKeyPath: "date", ascending: true))
        return items
    }
	
	static func deleteItems(withFilter filter: String) {
		let items: [ItemModel] = retrieveItems(withFilter: filter)
		realm.beginWrite()
		
		// Delete all non-default images related to the to-be-deleted items
		for item in items {
			if let image = retrieveItemImageById(item.image_id), !image.is_default {
				realm.delete(image)
			}
		}
		
		realm.delete(items)
		try! realm.commitWrite()
	}
	
	
	// MARK: ItemCategoryModel
    
    static func saveItemCategories(_ itemCategories: [ItemCategoryModel]) {
        realm.beginWrite()
        for itemCategory in itemCategories {
            realm.add(itemCategory)
        }
        try! realm.commitWrite()
    }
    
    static func saveItemCategory(_ itemCategory: ItemCategoryModel) {
		saveItemCategories([itemCategory])
    }
    
    static func deleteItemCategory(categoryId: Int) {
        if let itemCategoryToBeDeleted = RealmManager.retrieveItemCategoryById(categoryId) {
			deleteItems(withFilter: "category == \(categoryId)")
            realm.beginWrite()
            realm.delete(itemCategoryToBeDeleted)
            try! realm.commitWrite()
        }
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
		try! realm.commitWrite()
	}
	
	static func saveItemImage(_ itemImage: ItemImageModel) {
		saveItemImages([itemImage])
	}
	
	static func retrieveItemImages() -> [ItemImageModel] {
		let itemImages: [ItemImageModel] = Array(realm.objects(ItemImageModel.self))
		return itemImages
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
        try! realm.commitWrite()
    }
	
	static func retrieveItemMedals(category: Int) -> [MedalModel] {
		let count = realm.objects(MedalModel.self).filter("category == \(category)").map({ $0 })
		return Array(count)
	}
	
	
	// MARK: PersonalAspectsModel
	
	static func saveAspect(_ aspect: PersonalAspectsModel) {
		realm.beginWrite()
		realm.add(aspect)
		try! realm.commitWrite()
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
