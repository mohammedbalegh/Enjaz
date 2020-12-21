import UIKit

class SetDateAndTimeScreenVC: UIViewController {
	
	let calendarView = CalendarView()
		
	var popoverTableVC = PopoverTableVC()
	
	var calendarTypePopoverDataSource = ["التقويم الهجري", "التقويم الميلادي"]
	var monthPopoverDataSource: [String] = []
	var yearPopoverDataSource: [String] = []
	
	var selectedCalendarTypeIndex = 0
	var selectedMonthIndex = 0
	var selectedYearIndex = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		
		setupCalendarView()
		setMonthPopoverDataSource()
		setYearPopoverDataSource()
		
		updateMonthDays()
    }
	
		
	func setupCalendarView() {
		view.addSubview(calendarView)
		
		NSLayoutConstraint.activate([
			calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
			calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			calendarView.widthAnchor.constraint(equalToConstant: LayoutConstants.calendarViewWidth),
			calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
		
		calendarView.popoverCalendarBtnsHSV.calendarTypePopoverBtn.addTarget(self, action: #selector(onCalendarTypePopoverBtnTap), for: .touchUpInside)
		
		calendarView.popoverCalendarBtnsHSV.monthPopoverBtn.addTarget(self, action: #selector(onMonthPopoverBtnTap), for: .touchUpInside)
		
		calendarView.popoverCalendarBtnsHSV.yearPopoverBtn.addTarget(self, action: #selector(onYearPopoverBtnTap), for: .touchUpInside)
	}
	
	func setMonthPopoverDataSource() {
		if selectedCalendarTypeIndex == 0 { // Islamic calendar
			monthPopoverDataSource = MonthNames.islamicMonthNamesInArabic
		} else { // Gregorian calendar
			monthPopoverDataSource = MonthNames.gregorianMonthNamesInArabic
		}
	}
	
	func setYearPopoverDataSource() {
		var currentYearNumber: Int
		
		if selectedCalendarTypeIndex == 0 { // Islamic calendar
			currentYearNumber = DateAndTimeTools.getCurrentYearInIslamicCalendar()
		} else { // Gregorian calendar
			currentYearNumber = DateAndTimeTools.getCurrentYearInGeorgianCalendar()
		}
		
		var yearsArray: [String] = []
		for i in currentYearNumber...(currentYearNumber + 5) {
			yearsArray.append(String(i))
		}
		
		yearPopoverDataSource = yearsArray
	}
	
	@objc func onCalendarTypePopoverBtnTap() {
		popoverTableVC.dataSourceArray = calendarTypePopoverDataSource
		popoverTableVC.onSelectOption = onSelectCalendarType
		
		presentPopover(frame: calendarView.popoverCalendarBtnsHSV.calendarTypePopoverBtn.frame, numberOfOptions: calendarTypePopoverDataSource.count)
	}
	
	@objc func onMonthPopoverBtnTap() {
		popoverTableVC.dataSourceArray = monthPopoverDataSource
		popoverTableVC.onSelectOption = onSelectMonth
		
		presentPopover(frame: calendarView.popoverCalendarBtnsHSV.monthPopoverBtn.frame, numberOfOptions: monthPopoverDataSource.count)
	}
	
	@objc func onYearPopoverBtnTap() {
		popoverTableVC.dataSourceArray = yearPopoverDataSource
		popoverTableVC.onSelectOption = onSelectYear
		
		presentPopover(frame: calendarView.popoverCalendarBtnsHSV.yearPopoverBtn.frame, numberOfOptions: yearPopoverDataSource.count)
	}
	
	func presentPopover(frame: CGRect, numberOfOptions: Int) {
		popoverTableVC.modalPresentationStyle = .popover
		popoverTableVC.preferredContentSize = CGSize(width: LayoutConstants.calendarViewPopoverWidth, height: min(200, CGFloat(numberOfOptions) * LayoutConstants.calendarViewPopoverCellHeight))

		let popoverPresentationController = popoverTableVC.popoverPresentationController

		if let popoverPresentationController = popoverPresentationController {
			popoverPresentationController.permittedArrowDirections = .up
			popoverPresentationController.sourceView = calendarView.popoverCalendarBtnsHSV
			popoverPresentationController.sourceRect = frame
			popoverPresentationController.delegate = self
		}

		present(popoverTableVC, animated: true)
	}
	
	func onSelectCalendarType(selectedIndex: Int) {
		guard selectedIndex != selectedCalendarTypeIndex else { return }
		
		calendarView.popoverCalendarBtnsHSV.calendarTypePopoverBtn.label.text = calendarTypePopoverDataSource[selectedIndex]
		
		selectedCalendarTypeIndex = selectedIndex
		
		setMonthPopoverDataSource()
		setYearPopoverDataSource()
		
		calendarView.popoverCalendarBtnsHSV.monthPopoverBtn.label.text = monthPopoverDataSource[0]
		calendarView.popoverCalendarBtnsHSV.yearPopoverBtn.label.text = yearPopoverDataSource[0]
		
		updateMonthDays()
	}
	
	func onSelectMonth(selectedIndex: Int) {
		guard selectedIndex != selectedMonthIndex else { return }
		
		calendarView.popoverCalendarBtnsHSV.monthPopoverBtn.label.text = monthPopoverDataSource[selectedIndex]
		selectedMonthIndex = selectedIndex
		
		updateMonthDays()
	}
	
	func onSelectYear(selectedIndex: Int) {
		guard selectedIndex != selectedYearIndex else { return }
		
		calendarView.popoverCalendarBtnsHSV.yearPopoverBtn.label.text = yearPopoverDataSource[selectedIndex]
		selectedYearIndex = selectedIndex
		
		updateMonthDays()
	}
	
	func updateMonthDays() {
		let calendarType: NSCalendar.Identifier = selectedCalendarTypeIndex == 0 ? .islamicCivil : .gregorian
		let month = selectedMonthIndex + 1
		let year = Int(yearPopoverDataSource[selectedYearIndex]) ?? 0
		
		let (numberOfDaysInMonth, firstWeekDayNumber) = DateAndTimeTools.getNumberOfMonthDaysAndFirstWeekDay(ofYear: year, andMonth: month, forCalendarType: calendarType)
		
		calendarView.updateMonthDaysModel(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: firstWeekDayNumber - 1)
	}

}

extension SetDateAndTimeScreenVC: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}

	//UIPopoverPresentationControllerDelegate
	func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

	}

	func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
		return true
	}
}
