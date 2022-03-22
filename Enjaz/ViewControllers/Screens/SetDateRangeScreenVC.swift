import UIKit

class SetDateRangeScreenVC: SetDateAndTimeScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Start and End Date".localized
        calendarView.allowsRangeSelection = true
        calendarView.monthDaysCollectionView.deselectAllItems(animated: false)
    }
    
    override func setupSubviews() {
        setupCalendarView()
        setupSaveBtn()
		setupNextBtn()
    }
    
    override func handleSaveBtnTap() {
		guard let selectedDatesUnixTimeStamps = getSelectedTimeStamps() else { return }
		selectedDatesTimeStamps.append(selectedDatesUnixTimeStamps)
		
		let readableDate = numberOfPartitions > 1
			? getReadableDateForMultiplePartitions(selectedDatesTimeStamps: selectedDatesTimeStamps)
			: calendarView.selectedDaysLabel.text ?? ""
		
        delegate?.handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: selectedDatesTimeStamps, readableDate: readableDate, repetitionOption: nil)
        dismiss(animated: true)
    }
	
	func getReadableDateForMultiplePartitions(selectedDatesTimeStamps: [[TimeInterval]]) -> String {
		var multiplePartitionsReadableDates: [String] = []
		
		for partitionDates in selectedDatesTimeStamps {
			guard let firstPartitionTimeStamp = partitionDates.first, let lastPartitionTimeStamp = partitionDates.last else { continue }
			
			let firstPartitionDate = Date(timeIntervalSince1970: firstPartitionTimeStamp), lastPartitionDate = Date(timeIntervalSince1970: lastPartitionTimeStamp)
			
			let calendar = Calendar(identifier: selectedCalendarIdentifier)
			
			let firstSelectedDateYear = calendar.component(.year, from: firstPartitionDate)
			let lastSelectedDateYear = calendar.component(.year, from: lastPartitionDate)
			
			let dateFormat = firstSelectedDateYear == lastSelectedDateYear ? "d-M" : "d-M-yy"
			
			let firstPartitionReadableDate = Date.getReadableDate(from: firstPartitionDate, withFormat: dateFormat, calendarIdentifier: selectedCalendarIdentifier)
			
			let lastPartitionReadableDate = Date.getReadableDate(from: lastPartitionDate, withFormat: dateFormat, calendarIdentifier: selectedCalendarIdentifier)
			
			let partitionReadableDate = firstPartitionReadableDate + " : " + lastPartitionReadableDate
			multiplePartitionsReadableDates.append(partitionReadableDate)
		}
		
		return multiplePartitionsReadableDates.joined(separator: " | ")
	}
	
	override func getSelectedTimeStamps() -> [TimeInterval]? {
		guard let firstSelectedDate = firstSelectedDate, let lastSelectedDate = lastSelectedDate, firstSelectedDate != lastSelectedDate else {
			alertPopup.presentAsError(withMessage: "A date range must be selected".localized)
			return nil
		}
		
		let currentDateUnixTimeStamp = Date().timeIntervalSince1970
		let firstSelectedDateUnixTimeStamp = firstSelectedDate.timeIntervalSince1970
		
		if firstSelectedDateUnixTimeStamp < currentDateUnixTimeStamp {
			alertPopup.presentAsError(withMessage: "Selected date range cannot be in the past".localized)
			return nil
		}
		
		let selectedDatesUnixTimeStamps = getSelectedDates()!.map { $0.timeIntervalSince1970 }
		
		return selectedDatesUnixTimeStamps
	}
    
    func getSelectedDates() -> [Date]? {
        guard let firstSelectedDate = firstSelectedDate, let lastSelectedDate = lastSelectedDate else {
            return nil
        }
        
        let earlierDate = min(firstSelectedDate, lastSelectedDate)
        let laterDate = max(firstSelectedDate, lastSelectedDate)
        
        guard let numberOfDays = Date.getNumberOfDaysBetween(earlierDate, laterDate) else { return nil }
        
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
