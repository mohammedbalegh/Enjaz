import UIKit

class SetDateRangeScreenVC: SetDateAndTimeScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Start and End Date", comment: "")
        calendarView.allowsRangeSelection = true
        calendarView.monthDaysCollectionView.deselectAllItems(animated: false)
    }
    
    override func setupSubviews() {
        setupHeader()
        setupCalendarView()
        setupSaveBtn()
    }
    
    override func handleSaveBtnTap() {
        
        guard let firstSelectedDate = firstSelectedDate, let lastSelectedDate = lastSelectedDate, firstSelectedDate != lastSelectedDate else {
            alertPopup.showAsError(withMessage: NSLocalizedString("A date range must be selected", comment: ""))
            return
        }
        
        let currentDateUnixTimeStamp = Date().timeIntervalSince1970
        let firstSelectedDateUnixTimeStamp = firstSelectedDate.timeIntervalSince1970
        
        if firstSelectedDateUnixTimeStamp < currentDateUnixTimeStamp {
            alertPopup.showAsError(withMessage: NSLocalizedString("Selected date range cannot be in the past", comment: ""))
            return
        }
        
        let selectedDatesUnixTimeStamps = getSelectedDates()!.map { $0.timeIntervalSince1970 }
        
        delegate?.handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: selectedDatesUnixTimeStamps, readableDate: calendarView.selectedDaysLabel.text ?? "")
        dismiss(animated: true)
    }
    
    func getSelectedDates() -> [Date]? {
        guard let firstSelectedDate = firstSelectedDate, let lastSelectedDate = lastSelectedDate else {
            return nil
        }
        
        
        let earlierDate = min(firstSelectedDate, lastSelectedDate)
        let laterDate = max(firstSelectedDate, lastSelectedDate)
        
        guard let numberOfDays = DateAndTimeTools.getNumberOfDaysBetween(earlierDate, laterDate) else { return nil }
        
        var selectedDates: [Date] = [earlierDate]
        var lastDate = earlierDate
        let oneDayTimeInterval: TimeInterval = 24 * 60 * 60
        
        for _ in 1...numberOfDays {
            let newDate = lastDate.advanced(by: oneDayTimeInterval)
            selectedDates.append(newDate)
            lastDate = newDate
        }
        
        return selectedDates
    }
}
