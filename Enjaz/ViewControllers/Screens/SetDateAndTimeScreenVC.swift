import UIKit

class SetDateAndTimeScreenVC: UIViewController {
    
    var timeModel: [HourModel] = [HourModel(hour: 1, period: "am"),HourModel(hour: 2, period: "am"),HourModel(hour: 3, period: "am"),HourModel(hour: 4, period: "am"),HourModel(hour: 5, period: " am"),HourModel(hour: 6, period: "am"),HourModel(hour: 7, period: "am"),HourModel(hour: 8, period: "am"),HourModel(hour: 9, period: " am"),HourModel(hour: 10, period: "am"),HourModel(hour: 11, period: "am"),HourModel(hour: 12, period: "am"),HourModel(hour: 1, period: "pm"),HourModel(hour: 2, period: "pm"),HourModel(hour: 3, period: "pm"),HourModel(hour: 4, period: "pm"),HourModel(hour: 5, period: "pm"),HourModel(hour: 6, period: "pm"),HourModel(hour: 7, period: "pm"),HourModel(hour: 8, period: "pm"),HourModel(hour: 9, period: "pm"),HourModel(hour: 10, period: "pm"),HourModel(hour: 11, period: "pm"),HourModel(hour: 12, period: "pm")
    ]
    
    let cornerRadius = (LayoutConstants.screenWidth * 0.86) * 0.186
    let pickerWidth = LayoutConstants.screenHeight * 0.0853
    let pickerHeight = LayoutConstants.screenWidth * 0.104
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "التاريخ و الوقت"
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.textColor = .accentColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("الغاء", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.accentColor, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("حفظ", for: .normal)
        button.layer.cornerRadius = cornerRadius / 2
        button.titleLabel?.font = button.titleLabel?.font.withSize(25)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.2
        
        button.addTarget(self, action: #selector(onSaveBtnTap), for: .touchUpInside)
        
        return button
    }()
    
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
	
    var delegate: NewAdditionScreenModalDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        hourPicker =  HourPickerView()
        
        hourPicker.dataSource = hourPicker
        hourPicker.delegate = hourPicker
                
        setupSubviews()
		setupCalendarView()
		setMonthPopoverDataSource()
		setYearPopoverDataSource()
		
        setPopoverBtnsDefaultLables()
        
		updateMonthDays()
        
    }

    func setupSubviews() {
        setupTitleLabel()
        setupDismissButton()
        setupSaveButton()
        setupIndicator()
        setupHourPicker()
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        let width = LayoutConstants.screenWidth *  0.3
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.025),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: width),
            titleLabel.heightAnchor.constraint(equalToConstant: width * 0.22)
            
        ])
    }
	
		
	func setupCalendarView() {
		view.addSubview(calendarView)
		
		NSLayoutConstraint.activate([
			calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
			calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			calendarView.widthAnchor.constraint(equalToConstant: LayoutConstants.calendarViewWidth),
            calendarView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.45),
		])
		
		calendarView.popoverCalendarBtnsHSV.calendarTypePopoverBtn.addTarget(self, action: #selector(onCalendarTypePopoverBtnTap), for: .touchUpInside)
		
		calendarView.popoverCalendarBtnsHSV.monthPopoverBtn.addTarget(self, action: #selector(onMonthPopoverBtnTap), for: .touchUpInside)
		
		calendarView.popoverCalendarBtnsHSV.yearPopoverBtn.addTarget(self, action: #selector(onYearPopoverBtnTap), for: .touchUpInside)
	}
	
    
    func setupDismissButton() {
        view.addSubview(dismissButton)
        
        let width = LayoutConstants.screenWidth * 0.106
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.04),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.046),
            dismissButton.widthAnchor.constraint(equalToConstant: width),
            dismissButton.heightAnchor.constraint(equalToConstant: width * 0.106)
        ])
    }
    
    func setupSaveButton() {
        view.addSubview(saveButton)
        
        let width = LayoutConstants.screenWidth * 0.86
        let height = width * 0.182
        
        saveButton.applyAccentColorGradient(size: CGSize(width: width, height: height), cornerRadius: saveButton.layer.cornerRadius)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.04)),
            saveButton.widthAnchor.constraint(equalToConstant: width),
            saveButton.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func setupHourPicker() {
        view.addSubview(hourPicker)
        
        hourPicker.transform = CGAffineTransform(rotationAngle: (90 * (.pi / 180)))

        NSLayoutConstraint.activate([
            hourPicker.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: LayoutConstants.screenWidth * 0.1),
            hourPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hourPicker.heightAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.87),
            hourPicker.widthAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.085)
        ])
    }
    
    func setupIndicator() {
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -(LayoutConstants.screenWidth * 0.25)),
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
    
    func showDateInPastAlert() {
        let alert = UIAlertController(title: "خطأ", message: "لا يمكن اختيار تاريخ في الماضي", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func onSaveBtnTap() {
        let selectedDate = getSelectedDate()
        
        let currentDateUnixTimeStamp = Date().timeIntervalSince1970
        let slectedDateUnixTimeStamp = selectedDate.timeIntervalSince1970
        
        if slectedDateUnixTimeStamp < currentDateUnixTimeStamp {
            showDateInPastAlert()
            
            return
        }
        
        delegate?.onDateAndTimeSaveBtnTap(selectedTimeStamp: slectedDateUnixTimeStamp)
        dismiss(animated: true)
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
    
    func setPopoverBtnsDefaultLables() {
        calendarView.popoverCalendarBtnsHSV.calendarTypePopoverBtn.label.text = calendarTypePopoverDataSource[0]
        calendarView.popoverCalendarBtnsHSV.monthPopoverBtn.label.text = monthPopoverDataSource[0]
        calendarView.popoverCalendarBtnsHSV.yearPopoverBtn.label.text = yearPopoverDataSource[0]
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
        
        let date = DateAndTimeTools.genrateDateObjectFromComponents(year: year, month: month, day: day, hour: hour, calendarIdentifier: calendarType)
        
        return date
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
