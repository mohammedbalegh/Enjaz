import Foundation

struct DailyViewDayModel {
    let dayNumber: Int
	let month: Int
	let year: Int
	let calendarIdentifier: Calendar.Identifier
    let weekDayName: String
    let includedItems: [ItemModel]
}
