import Foundation

protocol NewAdditionScreenModalDelegate {
    func onDateAndTimeSaveBtnTap(selectedTimeStamp: Double, calendarIdentifier: NSCalendar.Identifier)
    func onTypeSaveBtnTap(id: Int)
}
