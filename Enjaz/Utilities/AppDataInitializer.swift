import Foundation

struct AppDataInitializer {
    static func initializeItemCategories() {
//        let itemCategoriesAreEmpty = RealmManager.itemCategoriesCount == 0
//        guard itemCategoriesAreEmpty else { return }
//
//        RealmManager.saveItemCategories(DEFAULT_ITEM_CATEGORIES)
        NetworkingManager.retreiveItemCategories { itemCategoryModels, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
//                    RealmManager.saveItemCategories(DEFAULT_ITEM_CATEGORIES)
                    return
                }

                if let itemCategoryModels = itemCategoryModels as? [ItemCategoryModel] {
                    RealmManager.saveItemCategories(itemCategoryModels)
                }
            }
        }
    }
	
	static func initializeItemImages() {
        NetworkingManager.retreiveItemImages { itemImageModels, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    RealmManager.saveItemImages(DEFAULT_ITEM_IMAGES)
                    return
                }
                
                if let itemImageModels = itemImageModels as? [ItemImageModel] {
                    RealmManager.saveItemImages(itemImageModels + DEFAULT_ITEM_IMAGES)
                } else {
                    RealmManager.saveItemImages(DEFAULT_ITEM_IMAGES)
                }
            }
        }
		
	}
        
    static func initializePersonalAspects() {
        if RealmManager.personalAspectsCount == 0 {
            addMainAspects(title: "Who am I", brief: "Write what you know about your self", image: "whoAmIImage", badge: "whoAmIBadge", description: "Translate what you know about your self from dreams and ambitions into goals, to achieve as much as possible year")
            
            addMainAspects(title: "My mission in life", brief: "Write your life mission", image: "lifeMissionImage", badge: "lifeMissionBadge", description: "Your life mission is you answer to the \"why\" question , what are the values that you stand behind, you life mission should be comprehensive, inspiring, and rememberable")
            
            addMainAspects(title: "My vision in life", brief: "Write your life vision", image: "visionImage", badge: "visionBadge", description: "life vision answers the \"why\" and \"where\" , where will your feature be ?, what it will be like, what will you do in 5 or 10 years ")
        }
        
    }
    
    private static func addMainAspects(title: String, brief: String, image: String, badge: String, description: String) {
        let aspect = PersonalAspectsModel()
        
        aspect.title = NSLocalizedString(title, comment: "")
        aspect.brief_or_date = NSLocalizedString(brief, comment: "")
        aspect.image_source = image
        aspect.badge_image_source = badge
        aspect.aspect_description = NSLocalizedString(description, comment: "")
        
        RealmManager.saveAspect(aspect)
    }
}
