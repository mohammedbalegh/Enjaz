import UIKit

struct WeekDayCellModel {
    var hourLabel: String?
    var includedItems: [ItemModel] = []
    var includesItems: Bool {
        return !includedItems.isEmpty
    }
}
