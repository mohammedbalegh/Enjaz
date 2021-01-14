import UIKit

class SetDateAndTimeScreenVC: UIViewController {
    
    var hourPickerModels: [HourModel] = ModelsConstants.hourPickerModels
    
    lazy var header: ModalHeader = {
        let header = ModalHeader(frame: .zero)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        header.titleLabel.text = "التاريخ و الوقت"
        header.dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        return header
    }()
    
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
    
    lazy var saveBtn = PrimaryBtn(label: "حفظ", theme: .blue, size: .large)
		
	var popoverTableVC = PopoverTableVC()
	
	var calendarTypePopoverDataSource = ["التقويم الهجري", "التقويم الميلادي"]
	var monthPopoverDataSource: [String] = []
	var yearPopoverDataSource: [String] = []
	
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
    
    var selectedCalendarIdentifier: NSCalendar.Identifier {
        return selectedCalendarTypeIndex == 0 ? .islamicCivil : .gregorian
    }
    
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
	
    var delegate: NewAdditionScreenModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        hourPicker.selectRow(12, inComponent: 0, animated: false)
        
        setMonthPopoverDataSource()
        setYearPopoverDataSource()
        updateMonthDays()
        
        setupSubviews()
    }

    func setupSubviews() {
        setupHeader()
        setPopoverBtnsDefaultLabels()
        setupCalendarView()
        setupSaveButton()
        setupIndicator()
        setupHourPicker()
    }
    
    func setupHeader() {
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
	func setupCalendarView() {
		view.addSubview(calendarView)
        
		NSLayoutConstraint.activate([
			calendarView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 35),
			calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			calendarView.widthAnchor.constraint(equalToConstant: CalendarView.width),
            calendarView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.45),
		])
		
		calendarView.calendarTypePopoverBtn.addTarget(self, action: #selector(onCalendarTypePopoverBtnTap), for: .touchUpInside)
		
		calendarView.monthPopoverBtn.addTarget(self, action: #selector(onMonthPopoverBtnTap), for: .touchUpInside)
		
		calendarView.yearPopoverBtn.addTarget(self, action: #selector(onYearPopoverBtnTap), for: .touchUpInside)
	}
	
    func setupSaveButton() {
        view.addSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        saveBtn.addTarget(self, action: #selector(onSaveBtnTap), for: .touchUpInside)
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
    
	@objc func onCalendarTypePopoverBtnTap() {
		popoverTableVC.dataSourceArray = calendarTypePopoverDataSource
		popoverTableVC.onSelectOption = onSelectCalendarType
		
		presentPopover(frame: calendarView.calendarTypePopoverBtn.frame, numberOfOptions: calendarTypePopoverDataSource.count)
	}
	
	@objc func onMonthPopoverBtnTap() {
		popoverTableVC.dataSourceArray = monthPopoverDataSource
		popoverTableVC.onSelectOption = onSelectMonth
		
		presentPopover(frame: calendarView.monthPopoverBtn.frame, numberOfOptions: monthPopoverDataSource.count)
	}
	
	@objc func onYearPopoverBtnTap() {
		popoverTableVC.dataSourceArray = yearPopoverDataSource
		popoverTableVC.onSelectOption = onSelectYear
		
		presentPopover(frame: calendarView.yearPopoverBtn.frame, numberOfOptions: yearPopoverDataSource.count)
	}
    	
    func onSelectCalendarType(selectedIndex: Int) {
        guard selectedIndex != selectedCalendarTypeIndex else { return }
        
        selectedCalendarTypeIndex = selectedIndex
        selectedMonthIndex = 0
        selectedYearIndex = 0
        
        calendarView.calendarTypeLabel = calendarTypePopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        setMonthPopoverDataSource()
        setYearPopoverDataSource()
        
        calendarView.monthLabel = monthPopoverDataSource[0]
        calendarView.yearLabel = yearPopoverDataSource[0]
        
        updateMonthDays()
    }
    
    func onSelectMonth(selectedIndex: Int) {
        guard selectedIndex != selectedMonthIndex else { return }
        
        selectedMonthIndex = selectedIndex
        calendarView.monthLabel = monthPopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        updateMonthDays()
    }
    
    func onSelectYear(selectedIndex: Int) {
        guard selectedIndex != selectedYearIndex else { return }
        
        selectedYearIndex = selectedIndex
        calendarView.yearLabel = yearPopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        updateMonthDays()
    }
    
    @objc func onSaveBtnTap() {
        guard calendarView.selectedMonthDayItemRow != nil else {
            alertPopup.showAsError(withMessage: "يجب تحديد اليوم")
            return
        }
        
        let selectedDate = getSelectedDate()
                
        let currentDateUnixTimeStamp = Date().timeIntervalSince1970
        let selectedDateUnixTimeStamp = selectedDate.timeIntervalSince1970
        
        if selectedDateUnixTimeStamp < currentDateUnixTimeStamp {
            alertPopup.showAsError(withMessage: "لا يمكن اختيار تاريخ في الماضي")
            return
        }
        
        delegate?.onDateAndTimeSaveBtnTap(selectedTimeStamp: selectedDateUnixTimeStamp, calendarIdentifier: selectedCalendarIdentifier)
        dismissModal()
    }
    
    // MARK: TOOLS
    
    func setMonthPopoverDataSource() {
        if selectedCalendarTypeIndex == 0 { // Islamic calendar
            monthPopoverDataSource = MonthNames.islamicMonthNamesInArabic
        } else { // Gregorian calendar
            monthPopoverDataSource = MonthNames.gregorianMonthNamesInArabic
        }
    }
    
    func setYearPopoverDataSource() {
        var currentYearNumber: Int
        
        currentYearNumber = DateAndTimeTools.getCurrentYear(islamic: selectedCalendarTypeIndex == 0)
        
        var yearsArray: [String] = []
        for i in currentYearNumber...(currentYearNumber + 5) {
            yearsArray.append(String(i))
        }
        
        yearPopoverDataSource = yearsArray
    }
    
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
    	
    func selectNextMonth() {
        if selectedMonthIsLastMonthInYear {
            guard !selectedYearIsLastSelectableYear else {
                calendarView.selectedMonthIsLastSelectableMonth = true
                return
            }
            
            let newSelectedYearIndex = selectedYearIndex + 1
            onSelectYear(selectedIndex: newSelectedYearIndex)
        }
        
        let newSelectedMonthIndex = (selectedMonthIndex + 1) % 12
        
        onSelectMonth(selectedIndex: newSelectedMonthIndex)
    }
        
    func setPopoverBtnsDefaultLabels() {
        calendarView.calendarTypeLabel = calendarTypePopoverDataSource[0]
        calendarView.monthLabel = monthPopoverDataSource[0]
        calendarView.yearLabel = yearPopoverDataSource[0]
    }
	
	func updateMonthDays() {
		let month = selectedMonthIndex + 1
        let year = DateAndTimeTools.getCurrentYear(islamic: selectedCalendarTypeIndex == 0) + selectedYearIndex
		
		let (numberOfDaysInMonth, firstWeekDayNumber) = DateAndTimeTools.getNumberOfMonthDaysAndFirstWeekDay(ofYear: year, andMonth: month, forCalendarIdentifier: selectedCalendarIdentifier)
		
		calendarView.updateMonthDaysModel(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: firstWeekDayNumber - 1)
	}
    
    func getSelectedDate(ofDay day: Int? = nil) -> Date {
        let day = day ?? calendarView.selectedDay
        let month = selectedMonthIndex + 1
        let year = DateAndTimeTools.getCurrentYear(islamic: selectedCalendarTypeIndex == 0) + selectedYearIndex
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
            let calendar = NSCalendar(identifier: selectedCalendarIdentifier)!
            
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
    
    @objc func dismissModal() {
        dismiss(animated: true)
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
