import UIKit

class SetDateAndTimeScreenVC: CardModalVC {
    
    var hourPickerModels: [HourModel] = ModelsConstants.hourPickerModels
    
    lazy var calendarView: CalendarView = {
        let calendarView = CalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.delegate = self
        
        return calendarView
    }()
    
    let cornerRadius = (LayoutConstants.screenWidth * 0.86) * 0.186
    let pickerWidth = LayoutConstants.screenHeight * 0.0853
    let pickerHeight = LayoutConstants.screenWidth * 0.104
    
    lazy var hourPicker: HourPickerView = {
        let picker = HourPickerView()
        
        picker.hourModels = hourPickerModels
        
        return picker
    }()
    
    lazy var indicator: UIView = {
        let view = UILabel()
        view.layer.cornerRadius = pickerHeight / 2
        view.clipsToBounds = true
        view.backgroundColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var saveBtn = PrimaryBtn(label: NSLocalizedString("Save", comment: ""), theme: .blue, size: .large)
		
	var popoverTableVC = PopoverTableVC()
	
    let calendarTypePopoverDataSource: [String] = {
        var calendarTypes = [NSLocalizedString("Georgian Calendar", comment: ""), NSLocalizedString("Hijri Calendar", comment: "")]
        
        if Locale.current.languageCode == "ar" {
            calendarTypes.reverse()
        }
        
        return calendarTypes
    }()
	lazy var monthPopoverDataSource = monthsNames
	lazy var yearPopoverDataSource = selectableYears
	
	var selectedCalendarTypeIndex = 0
	var selectedMonthIndex = 0
	var selectedYearIndex = 0
    
    var firstSelectedDate: Date?
    var lastSelectedDate: Date?
    
    var selectedYearIsLastSelectableYear: Bool {
        return selectedYearIndex == yearPopoverDataSource.count - 1
    }
    
    var selectedMonthIsLastMonthInYear: Bool {
        return selectedMonthIndex == 11
    }
    
    var selectedMonthIsLastSelectableMonth: Bool {
        return selectedMonthIsLastMonthInYear && selectedYearIsLastSelectableYear
    }
    
    var selectedCalendarIdentifier: Calendar.Identifier {
        let islamicCalendarIndex = Locale.current.languageCode == "ar" ? 0 : 1
        return selectedCalendarTypeIndex == islamicCalendarIndex ? .islamicCivil : .gregorian
    }
    
    var currentDay: Int {
        return DateAndTimeTools.getCurrentDay(forCalendarIdentifier: selectedCalendarIdentifier)
    }
    
    var currentMonth: Int {
        return DateAndTimeTools.getCurrentMonth(forCalendarIdentifier: selectedCalendarIdentifier)
    }
    
    var currentYear: Int {
        return DateAndTimeTools.getCurrentYear(forCalendarIdentifier: selectedCalendarIdentifier)
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: selectedCalendarIdentifier)
        return formatter
    }
    
    var monthsNames: [String] {
        return formatter.monthSymbols
    }
    
    var selectableYears: [String] {
        return (currentYear...currentYear + 5).map { String($0) }
    }
    
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
    var delegate: NewAdditionScreenModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("Date and Time", comment: "")
        
        setupSubviews()
        
        hourPicker.selectRow(12, inComponent: 0, animated: false)
        handleMonthSelection(selectedIndex: currentMonth - 1)
        selectCurrentDay()
    }

    func setupSubviews() {
        setPopoverBtnsDefaultLabels()
        setupCalendarView()
        setupSaveButton()
        setupIndicator()
        setupHourPicker()
    }
        
	func setupCalendarView() {
		view.addSubview(calendarView)
        
		NSLayoutConstraint.activate([
			calendarView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 35),
			calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			calendarView.widthAnchor.constraint(equalToConstant: CalendarView.width),
            calendarView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.45),
		])
		
		calendarView.calendarTypePopoverBtn.addTarget(self, action: #selector(handleCalendarTypePopoverBtnTap), for: .touchUpInside)
		calendarView.monthPopoverBtn.addTarget(self, action: #selector(handleMonthPopoverBtnTap), for: .touchUpInside)
		calendarView.yearPopoverBtn.addTarget(self, action: #selector(handleYearPopoverBtnTap), for: .touchUpInside)
	}
	
    func setupSaveButton() {
        view.addSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        saveBtn.addTarget(self, action: #selector(handleSaveBtnTap), for: .touchUpInside)
    }
    
    func setupHourPicker() {
        view.addSubview(hourPicker)
        hourPicker.translatesAutoresizingMaskIntoConstraints = false
        
        hourPicker.transform = CGAffineTransform(rotationAngle: (90 * (.pi / 180)))
        
        NSLayoutConstraint.activate([
            hourPicker.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: LayoutConstants.screenWidth * 0.1),
            hourPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hourPicker.heightAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.87),
            hourPicker.widthAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.085)
        ])
    }
    
    func setupIndicator() {
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: -(LayoutConstants.screenWidth * 0.25)),
            indicator.widthAnchor.constraint(equalToConstant: pickerHeight),
            indicator.heightAnchor.constraint(equalToConstant: pickerHeight * 1.7)
        ])
    }
    
    // MARK: Event Handlers
    
	@objc func handleCalendarTypePopoverBtnTap() {
		popoverTableVC.dataSourceArray = calendarTypePopoverDataSource
		popoverTableVC.optionSelectionHandler = handleCalendarTypeSelection
		
		presentPopover(frame: calendarView.calendarTypePopoverBtn.frame, numberOfOptions: calendarTypePopoverDataSource.count)
	}
	
	@objc func handleMonthPopoverBtnTap() {
		popoverTableVC.dataSourceArray = monthPopoverDataSource
		popoverTableVC.optionSelectionHandler = handleMonthSelection
		
		presentPopover(frame: calendarView.monthPopoverBtn.frame, numberOfOptions: monthPopoverDataSource.count)
	}
	
	@objc func handleYearPopoverBtnTap() {
		popoverTableVC.dataSourceArray = yearPopoverDataSource
		popoverTableVC.optionSelectionHandler = handleYearSelection
		
		presentPopover(frame: calendarView.yearPopoverBtn.frame, numberOfOptions: yearPopoverDataSource.count)
	}
    	
    func handleCalendarTypeSelection(selectedIndex: Int) {
        guard selectedIndex != selectedCalendarTypeIndex else { return }
                
        selectedCalendarTypeIndex = selectedIndex
        selectedMonthIndex = currentMonth - 1
        selectedYearIndex = 0
        
        calendarView.calendarTypeLabel = calendarTypePopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        monthPopoverDataSource = monthsNames
        yearPopoverDataSource = selectableYears
        
        calendarView.selectedMonthLabel = monthPopoverDataSource[selectedMonthIndex]
        calendarView.SelectedYearLabel = yearPopoverDataSource[selectedYearIndex]
        
        updateMonthDays()
        selectCurrentDay()
    }
    
    func handleMonthSelection(selectedIndex: Int) {
        selectedMonthIndex = selectedIndex
        calendarView.selectedMonthLabel = monthPopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        updateMonthDays()
    }
    
    func handleYearSelection(selectedIndex: Int) {
        guard selectedIndex != selectedYearIndex else { return }
                
        selectedYearIndex = selectedIndex
        calendarView.SelectedYearLabel = yearPopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        updateMonthDays()
    }
    
    @objc func handleSaveBtnTap() {
        guard calendarView.selectedMonthDayItemRow != nil else {
            alertPopup.showAsError(withMessage: NSLocalizedString("A day must be selected", comment: ""))
            return
        }
        
        let selectedDate = getSelectedDate()
                
        let currentDateUnixTimeStamp = Date().timeIntervalSince1970
        let selectedDateUnixTimeStamp = selectedDate.timeIntervalSince1970
        
        if selectedDateUnixTimeStamp < currentDateUnixTimeStamp {
            alertPopup.showAsError(withMessage: NSLocalizedString("Selected date cannot be in the past", comment: ""))
            return
        }
        
        delegate?.handleDateAndTimeSaveBtnTap(selectedTimeStamp: selectedDateUnixTimeStamp, calendarIdentifier: selectedCalendarIdentifier)
        dismissModal()
    }
    
    // MARK: TOOLS
    
	func presentPopover(frame: CGRect, numberOfOptions: Int) {
        popoverTableVC.modalPresentationStyle = .popover
		popoverTableVC.preferredContentSize = CGSize(width: LayoutConstants.calendarViewPopoverWidth, height: min(200, CGFloat(numberOfOptions) * LayoutConstants.calendarViewPopoverCellHeight))

		let popoverPresentationController = popoverTableVC.popoverPresentationController

		if let popoverPresentationController = popoverPresentationController {
			popoverPresentationController.permittedArrowDirections = .up
			popoverPresentationController.sourceView = calendarView.popoverCalendarBtnsRow
			popoverPresentationController.sourceRect = frame
			popoverPresentationController.delegate = self
		}

		present(popoverTableVC, animated: true)
	}
    
    func selectCurrentDay() {
        let currentDayIndexPath = IndexPath(row: currentDay - 1 + calendarView.monthDaysCollectionView.minimumSelectableItemRow, section: 0)
        
        calendarView.monthDaysCollectionView.selectItem(at: currentDayIndexPath, animated: true, scrollPosition: .centeredVertically)
        calendarView.collectionView(calendarView.monthDaysCollectionView, didSelectItemAt: currentDayIndexPath)
    }
    
    func selectNextMonth() {
        if selectedMonthIsLastMonthInYear {
            guard !selectedYearIsLastSelectableYear else {
                calendarView.selectedMonthIsLastSelectableMonth = true
                return
            }
            
            let newSelectedYearIndex = selectedYearIndex + 1
            handleYearSelection(selectedIndex: newSelectedYearIndex)
        }
        
        let newSelectedMonthIndex = (selectedMonthIndex + 1) % 12
        
        handleMonthSelection(selectedIndex: newSelectedMonthIndex)
    }
        
    func setPopoverBtnsDefaultLabels() {
        calendarView.calendarTypeLabel = calendarTypePopoverDataSource[0]
        calendarView.selectedMonthLabel = monthPopoverDataSource[0]
        calendarView.SelectedYearLabel = yearPopoverDataSource[0]
    }
	
	func updateMonthDays() {
		let month = selectedMonthIndex + 1
        let year = currentYear + selectedYearIndex
		
		let (numberOfDaysInMonth, firstWeekDayNumber) = DateAndTimeTools.getNumberOfMonthDaysAndFirstWeekDay(ofYear: year, andMonth: month, forCalendarIdentifier: selectedCalendarIdentifier)
		
		calendarView.updateMonthDaysModel(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: firstWeekDayNumber - 1)
	}
    
    func getSelectedDate(ofDay day: Int? = nil) -> Date {
        let day = day ?? calendarView.selectedDay
        let month = selectedMonthIndex + 1
        let year = currentYear + selectedYearIndex
        let time = hourPicker.hourModels[hourPicker.selectedTimePickerIndex]
        let hour = DateAndTimeTools.convertHourModelTo24HrFormatInt(time)
                
        let date = DateAndTimeTools.generateDateObjectFromComponents(year: year, month: month, day: day, hour: hour, calendarIdentifier: selectedCalendarIdentifier)
        
        return date
    }
    
    func getFirstSelectedDate() -> Date {
        return getSelectedDate(ofDay: calendarView.firstSelectedDay)
    }
    
    func getLastSelectedDate() -> Date {
        return getSelectedDate(ofDay: calendarView.lastSelectedDay)
    }
    
    func getReadableFirstAndLastSelectedDates() -> (String, String) {
        var format = "dd MMMM"
        
        var earlierDate = firstSelectedDate
        var laterDate = lastSelectedDate
        
        if let firstSelectedDate = firstSelectedDate, let lastSelectedDate = lastSelectedDate {
            let calendar = Calendar(identifier: selectedCalendarIdentifier)
            
            let firstSelectedDateYear = calendar.component(.year, from: firstSelectedDate)
            let lastSelectedDateYear = calendar.component(.year, from: lastSelectedDate)
            
            if firstSelectedDateYear != lastSelectedDateYear {
                format = "dd MMMM yyyy"
            }
            
            earlierDate = min(firstSelectedDate, lastSelectedDate)
            laterDate = firstSelectedDate == lastSelectedDate ? nil : max(firstSelectedDate, lastSelectedDate)
        }
                
        let readableFirstSelectedDate = DateAndTimeTools.getReadableDate(from: earlierDate, withFormat: format, calendarIdentifier: selectedCalendarIdentifier)
        
        let readableLastSelectedDate = DateAndTimeTools.getReadableDate(from: laterDate, withFormat: format, calendarIdentifier: selectedCalendarIdentifier)
        
        return (readableFirstSelectedDate, readableLastSelectedDate)
    }
    
    func updateCalendarViewSelectedDaysLabel() {
        let (readableFirstSelectedDate, readableLastSelectedDate) = getReadableFirstAndLastSelectedDates()
        calendarView.updateSelectedDaysLabel(firstDay: readableFirstSelectedDate, lastDay: readableLastSelectedDate)
    }
    
}


extension SetDateAndTimeScreenVC: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}

	func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
		return true
	}
}

extension SetDateAndTimeScreenVC: CalendarViewDelegate {
    func didUpdateFirstSelectedMonthDayItemRow(_ calendarView: CalendarView) {
        firstSelectedDate = getFirstSelectedDate()
        updateCalendarViewSelectedDaysLabel()
    }
        
    func didUpdateLastSelectedMonthDayItemRow(_ calendarView: CalendarView) {
        lastSelectedDate = getLastSelectedDate()
        updateCalendarViewSelectedDaysLabel()
    }
    
    func didLongPressOnLastItemDuringMultipleSelection(_ calendarView: CalendarView) {
        selectNextMonth()
    }
}
