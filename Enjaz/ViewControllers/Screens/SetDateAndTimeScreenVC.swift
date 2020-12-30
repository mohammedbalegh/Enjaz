import UIKit

class SetDateAndTimeScreenVC: UIViewController {
    
    var timeModel: [HourModel] = [HourModel(hour: 1, period: "am"),HourModel(hour: 2, period: "am"),HourModel(hour: 3, period: "am"),HourModel(hour: 4, period: "am"),HourModel(hour: 5, period: " am"),HourModel(hour: 6, period: "am"),HourModel(hour: 7, period: "am"),HourModel(hour: 8, period: "am"),HourModel(hour: 9, period: " am"),HourModel(hour: 10, period: "am"),HourModel(hour: 11, period: "am"),HourModel(hour: 12, period: "am"),HourModel(hour: 1, period: "pm"),HourModel(hour: 2, period: "pm"),HourModel(hour: 3, period: "pm"),HourModel(hour: 4, period: "pm"),HourModel(hour: 5, period: "pm"),HourModel(hour: 6, period: "pm"),HourModel(hour: 7, period: "pm"),HourModel(hour: 8, period: "pm"),HourModel(hour: 9, period: "pm"),HourModel(hour: 10, period: "pm"),HourModel(hour: 11, period: "pm"),HourModel(hour: 12, period: "pm")
    ]
    
    let cornerRadius = (LayoutConstants.screenWidth * 0.86) * 0.186
    let pickerWidth = LayoutConstants.screenHeight * 0.0853
    let pickerHeight = LayoutConstants.screenWidth * 0.104
    
    lazy var header: ModalHeader = {
        let header = ModalHeader(frame: .zero)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        header.titleLabel.text = "التاريخ و الوقت"
        header.dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        return header
    }()
    
    lazy var saveBtn = PrimaryBtn(label: "حفظ", theme: .blue, size: .large)
        
    var hourPicker: HourPickerView!
    var hourPickerDelegate: HourPickerDelegate!
    
    lazy var indicator: UIView = {
        let view = UILabel()
        view.layer.cornerRadius = pickerHeight / 2
        view.clipsToBounds = true
        view.backgroundColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
	
	let calendarView = CalendarView()
		
	var popoverTableVC = PopoverTableVC()
	
	var calendarTypePopoverDataSource = ["التقويم الهجري", "التقويم الميلادي"]
	var monthPopoverDataSource: [String] = []
	var yearPopoverDataSource: [String] = []
	
	var selectedCalendarTypeIndex = 0
	var selectedMonthIndex = 0
	var selectedYearIndex = 0
    
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
	
    var delegate: NewAdditionScreenModalDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        hourPicker =  HourPickerView()
        
        hourPicker.dataSource = hourPicker
        hourPicker.delegate = hourPicker

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
			calendarView.widthAnchor.constraint(equalToConstant: LayoutConstants.calendarViewWidth),
            calendarView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.45),
		])
		
		calendarView.popoverCalendarBtnsRow.calendarTypePopoverBtn.addTarget(self, action: #selector(onCalendarTypePopoverBtnTap), for: .touchUpInside)
		
		calendarView.popoverCalendarBtnsRow.monthPopoverBtn.addTarget(self, action: #selector(onMonthPopoverBtnTap), for: .touchUpInside)
		
		calendarView.popoverCalendarBtnsRow.yearPopoverBtn.addTarget(self, action: #selector(onYearPopoverBtnTap), for: .touchUpInside)
	}
	
    func setupSaveButton() {
        view.addSubview(saveBtn)
                
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.04)),
        ])
        
        saveBtn.addTarget(self, action: #selector(onSaveBtnTap), for: .touchUpInside)
    }
    
    func setupHourPicker() {
        view.addSubview(hourPicker)
        
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
	
	@objc func onCalendarTypePopoverBtnTap() {
		popoverTableVC.dataSourceArray = calendarTypePopoverDataSource
		popoverTableVC.onSelectOption = onSelectCalendarType
		
		presentPopover(frame: calendarView.popoverCalendarBtnsRow.calendarTypePopoverBtn.frame, numberOfOptions: calendarTypePopoverDataSource.count)
	}
	
	@objc func onMonthPopoverBtnTap() {
		popoverTableVC.dataSourceArray = monthPopoverDataSource
		popoverTableVC.onSelectOption = onSelectMonth
		
		presentPopover(frame: calendarView.popoverCalendarBtnsRow.monthPopoverBtn.frame, numberOfOptions: monthPopoverDataSource.count)
	}
	
	@objc func onYearPopoverBtnTap() {
		popoverTableVC.dataSourceArray = yearPopoverDataSource
		popoverTableVC.onSelectOption = onSelectYear
		
		presentPopover(frame: calendarView.popoverCalendarBtnsRow.yearPopoverBtn.frame, numberOfOptions: yearPopoverDataSource.count)
	}
    
    @objc func onSaveBtnTap() {
        guard calendarView.selectedMonthDayCellIndex != nil else {
            alertPopup.showAsError(withMessage: "يجب تحديد اليوم")
            return
        }
        
        let selectedDate = getSelectedDate()
        
        let calendarIdentifier: NSCalendar.Identifier = selectedCalendarTypeIndex == 0 ? .islamic : .gregorian
        
        let currentDateUnixTimeStamp = Date().timeIntervalSince1970
        let selectedDateUnixTimeStamp = selectedDate.timeIntervalSince1970
        
        if selectedDateUnixTimeStamp < currentDateUnixTimeStamp {
            alertPopup.showAsError(withMessage: "لا يمكن اختيار تاريخ في الماضي")
            return
        }
        
        delegate?.onDateAndTimeSaveBtnTap(selectedTimeStamp: selectedDateUnixTimeStamp, calendarIdentifier: calendarIdentifier)
        dismissModal()
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
    
	func onSelectCalendarType(selectedIndex: Int) {
		guard selectedIndex != selectedCalendarTypeIndex else { return }
		
		calendarView.popoverCalendarBtnsRow.calendarTypePopoverBtn.label.text = calendarTypePopoverDataSource[selectedIndex]
		
		selectedCalendarTypeIndex = selectedIndex
		
		setMonthPopoverDataSource()
		setYearPopoverDataSource()
		
		calendarView.popoverCalendarBtnsRow.monthPopoverBtn.label.text = monthPopoverDataSource[0]
		calendarView.popoverCalendarBtnsRow.yearPopoverBtn.label.text = yearPopoverDataSource[0]
		
		updateMonthDays()
	}
	
	func onSelectMonth(selectedIndex: Int) {
		guard selectedIndex != selectedMonthIndex else { return }
		
		calendarView.popoverCalendarBtnsRow.monthPopoverBtn.label.text = monthPopoverDataSource[selectedIndex]
		selectedMonthIndex = selectedIndex
		
		updateMonthDays()
	}
	
	func onSelectYear(selectedIndex: Int) {
		guard selectedIndex != selectedYearIndex else { return }
		
		calendarView.popoverCalendarBtnsRow.yearPopoverBtn.label.text = yearPopoverDataSource[selectedIndex]
		selectedYearIndex = selectedIndex
		
		updateMonthDays()
	}
    
    func setPopoverBtnsDefaultLabels() {
        calendarView.popoverCalendarBtnsRow.calendarTypePopoverBtn.label.text = calendarTypePopoverDataSource[0]
        calendarView.popoverCalendarBtnsRow.monthPopoverBtn.label.text = monthPopoverDataSource[0]
        calendarView.popoverCalendarBtnsRow.yearPopoverBtn.label.text = yearPopoverDataSource[0]
    }
	
	func updateMonthDays() {
		let calendarType: NSCalendar.Identifier = selectedCalendarTypeIndex == 0 ? .islamicCivil : .gregorian
		let month = selectedMonthIndex + 1
        let year = DateAndTimeTools.getCurrentYear(islamic: selectedCalendarTypeIndex == 0) + selectedYearIndex
		
		let (numberOfDaysInMonth, firstWeekDayNumber) = DateAndTimeTools.getNumberOfMonthDaysAndFirstWeekDay(ofYear: year, andMonth: month, forCalendarType: calendarType)
		
		calendarView.updateMonthDaysModel(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: firstWeekDayNumber - 1)
	}
    
    func getSelectedDate() -> Date {
        let day = calendarView.monthDayCellModels[calendarView.selectedMonthDayCellIndex ?? 0].dayNumber
        let month = selectedMonthIndex + 1
        let year = DateAndTimeTools.getCurrentYear(islamic: selectedCalendarTypeIndex == 0) + selectedYearIndex
        let time = timeModel[hourPicker.selectedTimePickerIndex]
        let hour = time.period == "pm" ? (time.hour + 12) % 24 : time.hour
        
        let calendarType: NSCalendar.Identifier = selectedCalendarTypeIndex == 0 ? .islamicCivil : .gregorian
        
        let date = DateAndTimeTools.generateDateObjectFromComponents(year: year, month: month, day: day, hour: hour, calendarIdentifier: calendarType)
        
        return date
    }
    
    @objc func dismissModal() {
        dismiss(animated: true)
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
