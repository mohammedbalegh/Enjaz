struct DailyViewHourModel {
    let hour: String
    var includedItems: [ItemModel]
    var isShowingAllIncludedItems: Bool
    var includesItems: Bool {
        return !includedItems.isEmpty
    }
}
