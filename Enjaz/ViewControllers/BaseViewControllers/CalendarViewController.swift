import UIKit

class CalendarViewController: UIViewController {
    
    lazy var calendarView: CalendarView = {
        let calendarView = CalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        configureCalendarPopoverBtnsRow(calendarPopoverBtnsRow: calendarView.calendarPopoverBtnsRow)
        
        calendarView.calendarTypePopoverBtn.addTarget(self, action: #selector(handleCalendarTypePopoverBtnTap), for: .touchUpInside)
        calendarView.viewTypePopoverBtn.addTarget(self, action: #selector(handleViewTypePopoverBtn), for: .touchUpInside)
        calendarView.monthPopoverBtn.addTarget(self, action: #selector(handleMonthPopoverBtnTap), for: .touchUpInside)
        calendarView.yearPopoverBtn.addTarget(self, action: #selector(handleYearPopoverBtnTap), for: .touchUpInside)
        calendarView.nextMonthBtn.addTarget(self, action: #selector(handleNextMonthBtnTap), for: .touchUpInside)
        calendarView.previousMonthBtn.addTarget(self, action: #selector(handlePreviousMonthBtnTap), for: .touchUpInside)
        calendarView.nextWeekBtn.addTarget(self, action: #selector(handleNextWeekBtnTap), for: .touchUpInside)
        calendarView.previousWeekBtn.addTarget(self, action: #selector(handlePreviousWeekBtnTap), for: .touchUpInside)
        
        return calendarView
    }()
    
    let cornerRadius = (LayoutConstants.screenWidth * 0.86) * 0.186
    let pickerWidth = LayoutConstants.screenHeight * 0.0853
    let pickerHeight = LayoutConstants.screenWidth * 0.104
    
    var popoverTableVC = PopoverTableVC()
    
    let calendarTypePopoverDataSource: [String] = {
        var calendarTypes = [NSLocalizedString("Georgian Calendar", comment: ""), NSLocalizedString("Hijri Calendar", comment: "")]
        
        if Locale.current.languageCode == "ar" {
            calendarTypes.reverse()
        }
        
        return calendarTypes
    }()
    
    let viewTypePopoverDataSource = [NSLocalizedString("Monthly View", comment: ""), NSLocalizedString("Weekly View", comment: "")]
    
    lazy var monthPopoverDataSource = monthsNames
    lazy var yearPopoverDataSource = selectableYears
    
    var selectedCalendarTypeIndex = 0
    var selectedViewTypeIndex = 0
    var selectedWeekIndex = 0
    var selectedMonthIndex = 0
    var selectedYearIndex = 0
    
    var firstSelectedDate: Date?
    var lastSelectedDate: Date?
    
    var numberOfWeeksInMonth: Int = 5
    
    var selectedYearIsLastSelectableYear: Bool {
        return selectedYearIndex == yearPopoverDataSource.count - 1
    }
    
    var selectedYearIsFirstSelectableYear: Bool {
        return selectedYearIndex == 0
    }
    
    var selectedMonthIsLastMonthInYear: Bool {
        return selectedMonthIndex == 11
    }
    
    var selectedMonthIsFirstMonthInYear: Bool {
        return selectedMonthIndex == 0
    }
    
    var selectedMonthIsLastSelectableMonth: Bool {
        return selectedMonthIsLastMonthInYear && selectedYearIsLastSelectableYear
    }
    
    var selectedMonthIsFirstSelectableMonth: Bool {
        return selectedMonthIsFirstMonthInYear && selectedYearIsFirstSelectableYear
    }
        
    var selectedWeekIsLastWeekInMonth: Bool {
        return selectedWeekIndex == numberOfWeeksInMonth - 1
    }
    
    var selectedWeekIsFirstWeekInMonth: Bool {
        return selectedWeekIndex == 0
    }
    
    var selectedWeekIsLastWeekInYear: Bool {
        return selectedWeekIsLastWeekInMonth && selectedMonthIsLastMonthInYear
    }
    
    var selectedWeekIsLastSelectableWeek: Bool {
        return selectedWeekIsLastWeekInYear && selectedYearIsLastSelectableYear
    }
    
    var selectedWeekIsFirstSelectableWeek: Bool {
        return selectedWeekIndex == 0 && selectedMonthIsFirstMonthInYear && selectedYearIsFirstSelectableYear
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
    
    let weekNames = [NSLocalizedString("First Week", comment: ""), NSLocalizedString("Second Week", comment: ""), NSLocalizedString("Third Week", comment: ""), NSLocalizedString("Fourth Week", comment: ""), NSLocalizedString("Last Week", comment: "")]
    
    var selectableYears: [String] {
        return (currentYear...currentYear + 5).map { String($0) }
    }
    
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
    var delegate: NewAdditionScreenModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setPopoverBtnsDefaultLabels()
        setupSubviews()
        handleMonthSelection(selectedIndex: currentMonth - 1)
    }

    func setupSubviews() {
        setupCalendarView()
    }
        
    func setupCalendarView() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.6),
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleCalendarTypePopoverBtnTap() {
        popoverTableVC.dataSourceArray = calendarTypePopoverDataSource
        popoverTableVC.optionSelectionHandler = handleCalendarTypeSelection
        
        presentPopover(frame: calendarView.calendarTypePopoverBtn.frame, numberOfOptions: calendarTypePopoverDataSource.count)
    }
    
    @objc func handleViewTypePopoverBtn() {
        popoverTableVC.dataSourceArray = viewTypePopoverDataSource
        popoverTableVC.optionSelectionHandler = handleViewTypeSelection
        
        presentPopover(frame: calendarView.viewTypePopoverBtn.frame, numberOfOptions: viewTypePopoverDataSource.count)
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
        calendarView.previousMonthBtn.isEnabled = !selectedMonthIsFirstSelectableMonth
        calendarView.nextMonthBtn.isEnabled = !selectedMonthIsLastSelectableMonth
        
        monthPopoverDataSource = monthsNames
        yearPopoverDataSource = selectableYears
        
        calendarView.selectedMonthLabel = monthPopoverDataSource[selectedMonthIndex]
        calendarView.selectedYearLabel = yearPopoverDataSource[selectedYearIndex]
        
        handleViewTypeSelection(selectedIndex: 0)
        updateMonthDays()
    }
    
    func handleViewTypeSelection(selectedIndex: Int) {
        guard selectedIndex != selectedViewTypeIndex else { return }
        
        selectedViewTypeIndex = selectedIndex
        calendarView.viewTypeLabel = viewTypePopoverDataSource[selectedIndex]
        handleWeekSelection(selectedIndex: 0)
        
        calendarView.showInWeeklyView = selectedIndex == 1
    }
    
    func handleWeekSelection(selectedIndex: Int) {
        selectedWeekIndex = selectedIndex
        calendarView.previousWeekBtn.isEnabled = !selectedWeekIsFirstSelectableWeek
        calendarView.nextWeekBtn.isEnabled = !selectedWeekIsLastSelectableWeek
        calendarView.handleNewWeekSelection(selectedWeekIndex: selectedIndex)
    }
    
    func handleMonthSelection(selectedIndex: Int) {
        selectedMonthIndex = selectedIndex
        calendarView.selectedMonthLabel = monthPopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        calendarView.previousMonthBtn.isEnabled = !selectedMonthIsFirstSelectableMonth
        calendarView.nextMonthBtn.isEnabled = !selectedMonthIsLastSelectableMonth
        
        updateMonthDays()
    }
    
    func handleYearSelection(selectedIndex: Int) {
        guard selectedIndex != selectedYearIndex else { return }
                
        selectedYearIndex = selectedIndex
        calendarView.selectedYearLabel = yearPopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        updateMonthDays()
    }
    
    @objc func handleNextMonthBtnTap() {
        switchToNextMonth(animated: true)
    }

    @objc func handlePreviousMonthBtnTap() {
        switchToPreviousMonth(animated: true)
    }

    @objc func handleNextWeekBtnTap() {
        switchToNextWeek()
    }

    @objc func handlePreviousWeekBtnTap() {
        switchToPreviousWeek()
    }
        
    // MARK: TOOLS
    
    // @abstract
    func configureCalendarPopoverBtnsRow(calendarPopoverBtnsRow: CalendarPopoverBtnsRow) {}
    
    func presentPopover(frame: CGRect, numberOfOptions: Int) {
        popoverTableVC.modalPresentationStyle = .popover
        popoverTableVC.preferredContentSize = CGSize(width: LayoutConstants.calendarViewPopoverWidth, height: min(200, CGFloat(numberOfOptions) * LayoutConstants.calendarViewPopoverCellHeight))
        
        let popoverPresentationController = popoverTableVC.popoverPresentationController

        if let popoverPresentationController = popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = calendarView.calendarPopoverBtnsRow
            popoverPresentationController.sourceRect = frame
            popoverPresentationController.delegate = self
        }

        present(popoverTableVC, animated: true)
    }

    func switchToNextMonth(animated: Bool) {
        if selectedMonthIsLastMonthInYear {
            guard !selectedMonthIsLastSelectableMonth else {
                calendarView.selectedMonthIsLastSelectableMonth = true
                return
            }
            
            let newSelectedYearIndex = selectedYearIndex + 1
            handleYearSelection(selectedIndex: newSelectedYearIndex)
        }
        
        let newSelectedMonthIndex = (selectedMonthIndex + 1) % 12
                
        if animated {
            calendarView.monthDaysCollectionView.translateHorizontallyOutAndInSuperView(withDuration: 0.25, atDirection: .trailingToLeading, fadeOutAndIn: true, midAnimationCompletionHandler:  {_ in
                self.handleMonthSelection(selectedIndex: newSelectedMonthIndex)
            })
        } else {
            handleMonthSelection(selectedIndex: newSelectedMonthIndex)
        }
    }
    
    func switchToPreviousMonth(animated: Bool) {
        if selectedMonthIsFirstMonthInYear {
            guard !selectedMonthIsFirstSelectableMonth else { return }
            
            let newSelectedYearIndex = selectedYearIndex - 1
            handleYearSelection(selectedIndex: newSelectedYearIndex)
        }
        
        let newSelectedMonthIndex = selectedMonthIndex == 0 ? 11 : selectedMonthIndex - 1
        
        if animated {
            calendarView.monthDaysCollectionView.translateHorizontallyOutAndInSuperView(withDuration: 0.25, atDirection: .leadingToTrailing, fadeOutAndIn: true, midAnimationCompletionHandler: {_ in
                self.handleMonthSelection(selectedIndex: newSelectedMonthIndex)
            })
        } else {
            handleMonthSelection(selectedIndex: newSelectedMonthIndex)
        }
    }
    
    func switchToNextWeek() {
        var newSelectedWeekIndex: Int!
        if selectedWeekIsLastWeekInMonth {
            guard !selectedWeekIsLastSelectableWeek else { return }
            
            newSelectedWeekIndex = (selectedWeekIndex + 1) % numberOfWeeksInMonth
            switchToNextMonth(animated: false)
        }
        
        newSelectedWeekIndex = newSelectedWeekIndex ?? (selectedWeekIndex + 1) % numberOfWeeksInMonth
        
        calendarView.calendarContainer.translateHorizontallyOutAndInSuperView(withDuration: 0.25, atDirection: .trailingToLeading, fadeOutAndIn: true, midAnimationCompletionHandler:  {_ in
            self.handleWeekSelection(selectedIndex: newSelectedWeekIndex)
        })
    }
    
    func switchToPreviousWeek() {
        if selectedWeekIsFirstWeekInMonth {
            guard !selectedWeekIsFirstSelectableWeek else { return }
            
            switchToPreviousMonth(animated: false)
        }
        
        let newSelectedWeekIndex = selectedWeekIndex == 0 ? numberOfWeeksInMonth - 1 : selectedWeekIndex - 1
        
        print("numberOfWeeksInMonth inside switchToPreviousWeek \(numberOfWeeksInMonth)")
        
        calendarView.calendarContainer.translateHorizontallyOutAndInSuperView(withDuration: 0.25, atDirection: .leadingToTrailing, fadeOutAndIn: true, midAnimationCompletionHandler: {_ in
            self.handleWeekSelection(selectedIndex: newSelectedWeekIndex)
        })
    }
        
    func setPopoverBtnsDefaultLabels() {
        calendarView.calendarTypeLabel = calendarTypePopoverDataSource[0]
        calendarView.viewTypeLabel = viewTypePopoverDataSource[0]
        calendarView.selectedMonthLabel = monthPopoverDataSource[0]
        calendarView.selectedYearLabel = yearPopoverDataSource[0]
    }
    
    func updateMonthDays() {
        let month = selectedMonthIndex + 1
        let year = currentYear + selectedYearIndex
        
        let (numberOfDaysInMonth, firstWeekDayNumber) = DateAndTimeTools.getNumberOfMonthDaysAndFirstWeekDay(ofYear: year, andMonth: month, forCalendarIdentifier: selectedCalendarIdentifier)
        
        numberOfWeeksInMonth = getNumberOfWeeksInMonth(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: firstWeekDayNumber - 1)
        print("numberOfWeeksInMonth inside updateMonthDays \(numberOfWeeksInMonth)")
        
        calendarView.handleNewMonthSelection(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnIndex: firstWeekDayNumber - 1)
    }
    
    func getNumberOfWeeksInMonth(numberOfDaysInMonth: Int, startsAtColumnNumber firstColumnNumber: Int) -> Int {
        return Int(ceil(Double(numberOfDaysInMonth + firstColumnNumber) / 7))
    }
    
}


extension CalendarViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
