import UIKit

class SetDateAndTimeScreenVC: CalendarViewController {
    
    var hourPickerModels: [HourModel] = ModelsConstants.hourPickerModels
        
    lazy var hourPicker: HourPickerView = {
        let picker = HourPickerView()
        
        picker.hourModels = hourPickerModels
        
        return picker
    }()
	
    lazy var indicator: UIView = {
        let view = UILabel()
        view.layer.cornerRadius = pickerHeight / 2
        view.clipsToBounds = true
        view.backgroundColor = .accent
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var saveBtn = PrimaryBtn(label: NSLocalizedString("Save", comment: ""), theme: .blue, size: .large)
	var nextBtn: PrimaryBtn = {
		let button = PrimaryBtn(label: NSLocalizedString("Next", comment: ""), theme: .blue, size: .large)
		button.isHidden = true
		return button
	}()
	
	var partitionsNumberPopoverDataSource = ["1", "2", "3"]
	
	var selectedDatesTimeStamps: [[TimeInterval]] = []
		
	var selectedPartitionsNumberIndex = 0 {
		didSet {
			let currentPartitionNumber = selectedDatesTimeStamps.count
			nextBtn.isHidden = currentPartitionNumber == numberOfPartitions - 1
			saveBtn.isHidden = !nextBtn.isHidden
		}
	}
	
	var numberOfPartitions: Int {
		return Int(partitionsNumberPopoverDataSource[selectedPartitionsNumberIndex])!
	}
	
	var itemType: ItemType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Date and Time", comment: "")
        
        calendarView.delegate = self
        hourPicker.selectRow(12, inComponent: 0, animated: false)
        selectCurrentDay()
		
		if itemType == .goal {
			calendarView.partitionsNumberPopoverBtn.isHidden = false
			calendarView.partitionsNumberPopoverBtn.addTarget(self, action: #selector(handlePartitionsNumberPopoverBtnTap), for: .touchUpInside)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		let window = UIApplication.shared.windows[0]
		window.backgroundColor = .black
		
		if isPresentedModally && LayoutConstants.isScreenTall {
			navigationController?.navigationBar.prefersLargeTitles = true
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		if presentingViewController?.isPresentedModally == false {
			let window = UIApplication.shared.windows[0]
			window.backgroundColor = .background
		}
	}

    override func setupSubviews() {
        super.setupSubviews()
        setupSaveBtn()
		setupNextBtn()
        setupIndicator()
        setupHourPicker()
    }
        
    override func setupCalendarView() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
			calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.widthAnchor.constraint(equalToConstant: CalendarView.width),
            calendarView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.75),
        ])
    }
    
    func setupSaveBtn() {
        view.addSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        saveBtn.addTarget(self, action: #selector(handleSaveBtnTap), for: .touchUpInside)
    }
	
	func setupNextBtn() {
		view.addSubview(nextBtn)
		nextBtn.constrainEdgesToCorrespondingEdges(of: saveBtn, top: 0, leading: 0, bottom: 0, trailing: 0)
		nextBtn.addTarget(self, action: #selector(handleNextBtnTap), for: .touchUpInside)
	}
    
    func setupHourPicker() {
        view.addSubview(hourPicker)
        hourPicker.translatesAutoresizingMaskIntoConstraints = false
        
        hourPicker.transform = CGAffineTransform(rotationAngle: (90 * (.pi / 180)))
        
        NSLayoutConstraint.activate([
            hourPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hourPicker.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: LayoutConstants.screenWidth * 0.2),
            hourPicker.heightAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.87),
            hourPicker.widthAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.085)
        ])
    }
    
    func setupIndicator() {
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: -(LayoutConstants.screenWidth * 0.14)),
            indicator.widthAnchor.constraint(equalToConstant: pickerHeight),
            indicator.heightAnchor.constraint(equalToConstant: pickerHeight * 1.7)
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleDismissBtnTap() {
        dismiss(animated: true)
    }
	    
    override func handleCalendarTypeSelection(selectedIndex: Int) {
        super.handleCalendarTypeSelection(selectedIndex: selectedIndex)
        selectCurrentDay()
    }
	
	@objc func handlePartitionsNumberPopoverBtnTap() {
		popoverTableVC.dataSourceArray = partitionsNumberPopoverDataSource
		popoverTableVC.optionSelectionHandler = handlePartitionsNumberSelection
		
		let buttonFrame = calendarView.partitionsNumberPopoverBtn.frame
		
		let frame = CGRect(x: buttonFrame.minX, y: buttonFrame.minY - 60, width: buttonFrame.width, height: buttonFrame.height)
		
		presentPopover(frame: frame, numberOfOptions: partitionsNumberPopoverDataSource.count)
	}
	
	func handlePartitionsNumberSelection(selectedIndex: Int) {
		guard selectedIndex != selectedPartitionsNumberIndex else { return }
		
		selectedPartitionsNumberIndex = selectedIndex
		calendarView.partitionsNumberLabel = partitionsNumberPopoverDataSource[selectedIndex]
	}
    
	@objc func handleNextBtnTap() {
		guard let selectedDateUnixTimeStamps = getSelectedTimeStamps() else { return }
		selectedDatesTimeStamps.append(selectedDateUnixTimeStamps)
		
		let setDateAndTimeScreen = Self.init()
		
		setDateAndTimeScreen.selectedDatesTimeStamps = selectedDatesTimeStamps
		setDateAndTimeScreen.selectedPartitionsNumberIndex = selectedPartitionsNumberIndex
		setDateAndTimeScreen.calendarView.partitionsNumberLabel = calendarView.partitionsNumberLabel
		setDateAndTimeScreen.calendarView.partitionsNumberPopoverBtn.isEnabled = false
		setDateAndTimeScreen.itemType = itemType
		setDateAndTimeScreen.delegate = delegate
		
		navigationController?.pushViewController(setDateAndTimeScreen, animated: true)
	}
	
    @objc func handleSaveBtnTap() {
		guard let selectedDateUnixTimeStamps = getSelectedTimeStamps() else { return }
		selectedDatesTimeStamps.append(selectedDateUnixTimeStamps)
		
		let date = Date(timeIntervalSince1970: selectedDateUnixTimeStamps.first!)
		
		let readableDate = Date.getReadableDate(from: date, withFormat: "hh:00 aa | dd MMMM yyyy", calendarIdentifier: selectedCalendarIdentifier)
		
        delegate?.handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: selectedDatesTimeStamps, readableDate: readableDate)
        dismiss(animated: true)
    }
    
    // MARK: TOOLS
    
	override func setPopoverBtnsDefaultLabels() {
		super.setPopoverBtnsDefaultLabels()
		calendarView.partitionsNumberLabel = calendarView.partitionsNumberLabel ?? NSLocalizedString("Number of partitions", comment: "")
	}
	
    override func configureCalendarPopoverBtnsRow(calendarPopoverBtnsRow: CalendarPopoverBtnsRow) {
        calendarPopoverBtnsRow.configureWithBtns(firstBtn: .calendarType, secondBtn: .month, thirdBtn: .year)
    }
    
    func selectCurrentDay() {
        let currentDayIndexPath = IndexPath(row: currentDay - 1 + calendarView.monthDaysCollectionView.minimumSelectableItemRow, section: 0)
        
        calendarView.monthDaysCollectionView.selectItem(at: currentDayIndexPath, animated: true, scrollPosition: .centeredVertically)
        calendarView.collectionView(calendarView.monthDaysCollectionView, didSelectItemAt: currentDayIndexPath)
    }
    
	func getSelectedTimeStamps() -> [TimeInterval]? {
		guard calendarView.selectedMonthDayItemRow != nil else {
			alertPopup.presentAsError(withMessage: NSLocalizedString("A day must be selected", comment: ""))
			return nil
		}
		
		let selectedDate = getSelectedDate()
		
		let currentDateUnixTimeStamp = Date().timeIntervalSince1970
		let selectedDateUnixTimeStamp = selectedDate.timeIntervalSince1970
		
		if selectedDateUnixTimeStamp < currentDateUnixTimeStamp {
			alertPopup.presentAsError(withMessage: NSLocalizedString("Selected date cannot be in the past", comment: ""))
			return nil
		}
		
		return ([selectedDateUnixTimeStamp])
	}
	
    func getSelectedDate(ofDay day: Int? = nil) -> Date {
        let day = day ?? calendarView.selectedDay
        let month = selectedMonthIndex + 1
        let year = currentYear + selectedYearIndex
        let time = hourPicker.hourModels[hourPicker.selectedTimePickerIndex]
        let hour = Date.convertHourModelTo24HrFormatInt(time)
		
        let date = Date.generateDateObjectFromComponents(year: year, month: month, day: day, hour: hour, calendarIdentifier: selectedCalendarIdentifier)
        
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
				format = itemType == .goal ? "d-M-yyyy" : "dd MMMM yyyy"
            }
            
            earlierDate = min(firstSelectedDate, lastSelectedDate)
            laterDate = firstSelectedDate == lastSelectedDate ? nil : max(firstSelectedDate, lastSelectedDate)
        }
		
        let readableFirstSelectedDate = Date.getReadableDate(from: earlierDate, withFormat: format, calendarIdentifier: selectedCalendarIdentifier)
        
        let readableLastSelectedDate = Date.getReadableDate(from: laterDate, withFormat: format, calendarIdentifier: selectedCalendarIdentifier)
        
        return (readableFirstSelectedDate, readableLastSelectedDate)
    }
    
    func updateCalendarViewSelectedDaysLabel() {
        let (readableFirstSelectedDate, readableLastSelectedDate) = getReadableFirstAndLastSelectedDates()
        calendarView.updateSelectedDaysLabel(firstDay: readableFirstSelectedDate, lastDay: readableLastSelectedDate)
    }
    
}

extension SetDateAndTimeScreenVC: CalendarViewDelegate {
    func calendarCollectionView(_ calendarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        firstSelectedDate = nil
        lastSelectedDate = nil
        updateCalendarViewSelectedDaysLabel()
    }
    
    func didUpdateFirstSelectedMonthDayItemRow(_ calendarView: CalendarView) {
        firstSelectedDate = getFirstSelectedDate()
        updateCalendarViewSelectedDaysLabel()
    }
        
    func didUpdateLastSelectedMonthDayItemRow(_ calendarView: CalendarView) {
        lastSelectedDate = getLastSelectedDate()
        updateCalendarViewSelectedDaysLabel()
    }
    
    func didLongPressOnLastItemDuringMultipleSelection(_ calendarView: CalendarView) {
        switchToNextMonth(animated: false)
    }
}
