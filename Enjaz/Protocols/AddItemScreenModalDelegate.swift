import Foundation

protocol AddItemScreenModalDelegate {
    func handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: [[TimeInterval]], readableDate: String)
}
