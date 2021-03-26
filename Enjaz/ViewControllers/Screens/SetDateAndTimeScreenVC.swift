import UIKit

class SetDateAndTimeScreenVC: CalendarViewController {
    
    var hourPickerModels: [HourModel] = ModelsConstants.hourPickerModels
    
    let header = ModalHeader(frame: .zero)
    
    override var title: String? {
        didSet {
            header.titleLabel.text = title
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Date and Time", comment: "")
                
        hourPicker.selectRow(12, inComponent: 0, animated: false)
        selectCurrentDay()
    }

    override func setupSubviews() {
        setupHeader()
        super.setupSubviews()
        setupSaveButton()
        setupIndicator()
        setupHourPicker()
    }
    
    func setupHeader() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        header.dismissButton.addTarget(self, action: #selector(handleDismissBtnTap), for: .touchUpInside)
    }
    
    override func setupCalendarView() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 35),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.widthAnchor.constraint(equalToConstant: CalendarView.width),
            calendarView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.75),
        ])
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
            hourPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hourPicker.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: LayoutConstants.screenWidth * 0.1),
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
    
    @objc func handleDismissBtnTap() {
        dismiss(animated: true)
    }
    
    override func handleCalendarTypeSelection(selectedIndex: Int) {
        super.handleCalendarTypeSelection(selectedIndex: selectedIndex)
        selectCurrentDay()
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
        dismiss(animated: true)
    }
    
    // MARK: TOOLS
    
    override func configureCalendarPopoverBtnsRow(calendarPopoverBtnsRow: CalendarPopoverBtnsRow) {
        calendarPopoverBtnsRow.configureWithBtns(firstBtn: .calendarType, secondBtn: .month, thirdBtn: .year)
    }
    
    func selectCurrentDay() {
        let currentDayIndexPath = IndexPath(row: currentDay - 1 + calendarView.monthDaysCollectionView.minimumSelectableItemRow, section: 0)
        
        calendarView.monthDaysCollectionView.selectItem(at: currentDayIndexPath, animated: true, scrollPosition: .centeredVertically)
        calendarView.collectionView(calendarView.monthDaysCollectionView, didSelectItemAt: currentDayIndexPath)
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
        switchToNextMonth()
    }
}
