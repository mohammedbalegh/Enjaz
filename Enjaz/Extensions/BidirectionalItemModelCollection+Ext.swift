import Foundation

extension BidirectionalCollection where Element: ItemModel {
    
    func filterOutNonOriginalItems() -> [ItemModel] {
        var filteredItems: [ItemModel] = []
        var filteredItemsIds: [Int] = []
        
        for item in self {
            if !item.isOriginal {
                let originalItemIsAlreadyInFilteredItems = filteredItemsIds.contains(item.originalItemId)
                
                if !originalItemIsAlreadyInFilteredItems, let originalItem = RealmManager.retrieveItemById(item.originalItemId) {
                    filteredItems.append(originalItem)
                    filteredItemsIds.append(originalItem.id)
                }
                
                guard let originalItemIndex = filteredItemsIds.firstIndex(of: item.originalItemId) else { continue }
                
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
        newItem.endDate = item.endDate
        newItem.item_description = item.item_description
        newItem.category = item.category
        newItem.type = item.type
        newItem.is_completed = isCompleted
        newItem.image_id = item.image_id
        newItem.sticker_id = item.sticker_id
        newItem.originalItemId = item.originalItemId
        
        return newItem
    }
}
