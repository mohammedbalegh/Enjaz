struct MonthDayCellModel {
	var dayNumber: Int
    var includedItems: [ItemModel]
    var includesItem: Bool {
        get {
            !includedItems.isEmpty
        }
    }
}
