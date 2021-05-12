import Foundation

extension BidirectionalCollection where Element: ItemModel {
    
    func filterOutNonOriginalItems() -> [ItemModel] {
        var filteredItems: [ItemModel] = []
        var filteredItemsIds: [Int] = []
        
        for item in self {
            if !item.is_original {
                let originalItemIsAlreadyInFilteredItems = filteredItemsIds.contains(item.original_item_id)
                
                if !originalItemIsAlreadyInFilteredItems, let originalItem = RealmManager.retrieveItemById(item.original_item_id) {
                    filteredItems.append(originalItem)
                    filteredItemsIds.append(originalItem.id)
                }
                
                guard let originalItemIndex = filteredItemsIds.firstIndex(of: item.original_item_id) else { continue }
                
                let updatedOriginalItem: ItemModel = {
                    let originalItem = filteredItems[originalItemIndex]
                    let updatedItem = copyItem(originalItem, isCompleted: originalItem.is_completed && item.is_completed)
                    return updatedItem
                }()
                
                filteredItems.remove(at: originalItemIndex)
                filteredItems.insert(updatedOriginalItem, at: originalItemIndex)
                
                continue
            }
            
            filteredItems.append(item)
            filteredItemsIds.append(item.id)
        }
        
        return filteredItems
    }
    
    private func copyItem(_ item: ItemModel, isCompleted: Bool) -> ItemModel {
        let newItem = ItemModel()
        
        newItem.id = item.id
        newItem.name = item.name
        newItem.date = item.date
        newItem.end_date = item.end_date
        newItem.item_description = item.item_description
        newItem.category_id = item.category_id
        newItem.type_id = item.type_id
        newItem.is_completed = isCompleted
        newItem.image_id = item.image_id
        newItem.original_item_id = item.original_item_id
        
        return newItem
    }
}
