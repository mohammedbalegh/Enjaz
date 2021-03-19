import Foundation

protocol NewAdditionScreenModalDelegate {
    func handleDateAndTimeSaveBtnTap(selectedTimeStamp: Double, calendarIdentifier: Calendar.Identifier)
    func handleTypeSaveBtnTap(id: Int)
}
