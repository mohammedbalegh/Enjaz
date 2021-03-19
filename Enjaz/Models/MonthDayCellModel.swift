struct MonthDayCellModel {
	var dayNumber: Int
    var includedItemsIndices: [Int]
    var includesItem: Bool {
        get {
            includedItemsIndices.count > 0
        }
    }
}
