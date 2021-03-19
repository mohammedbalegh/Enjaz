import UIKit

class CalendarViewController: UIViewController {
    
    lazy var calendarView: CalendarView = {
        let calendarView = CalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        calendarView.calendarPopoverBtnsRow = getCalendarViewPopoverBtnsRow()
        
        calendarView.calendarTypePopoverBtn.addTarget(self, action: #selector(handleCalendarTypePopoverBtnTap), for: .touchUpInside)
        calendarView.viewTypePopoverBtn.addTarget(self, action: #selector(handleViewTypePopoverBtn), for: .touchUpInside)
        calendarView.monthPopoverBtn.addTarget(self, action: #selector(handleMonthPopoverBtnTap), for: .touchUpInside)
        calendarView.yearPopoverBtn.addTarget(self, action: #selector(handleYearPopoverBtnTap), for: .touchUpInside)
        calendarView.nextMonthBtn.addTarget(self, action: #selector(selectNextMonth), for: .touchUpInside)
        calendarView.previousMonthBtn.addTarget(self, action: #selector(selectPreviousMonth), for: .touchUpInside)
        
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
    var selectedMonthIndex = 0
    var selectedYearIndex = 0
    
    var firstSelectedDate: Date?
    var lastSelectedDate: Date?
    
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
        
        setPopoverBtnsDefaultLabels()
        setupSubviews()
        handleMonthSelection(selectedIndex: currentMonth - 1)
        selectCurrentDay()
    }

    func setupSubviews() {
        setupCalendarView()
    }
        
    func setupCalendarView() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.widthAnchor.constraint(equalToConstant: CalendarView.width),
            calendarView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
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
        
        monthPopoverDataSource = monthsNames
        yearPopoverDataSource = selectableYears
        
        calendarView.selectedMonthLabel = monthPopoverDataSource[selectedMonthIndex]
        calendarView.selectedYearLabel = yearPopoverDataSource[selectedYearIndex]
        
        updateMonthDays()
        selectCurrentDay()
    }
    
    func handleViewTypeSelection(selectedIndex: Int) {
        selectedViewTypeIndex = selectedIndex
        calendarView.viewTypeLabel = viewTypePopoverDataSource[selectedIndex]
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
        calendarView.selectedYearLabel = yearPopoverDataSource[selectedIndex]
        calendarView.selectedMonthIsLastSelectableMonth = selectedMonthIsLastSelectableMonth
        
        updateMonthDays()
    }
        
    // MARK: TOOLS
    
    func getCalendarViewPopoverBtnsRow() -> CalendarPopoverBtnsRow {
        return CalendarPopoverBtnsRow(firstBtn: nil, secondBtn: nil, thirdBtn: nil)
    }
    
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
    
    func selectCurrentDay() {
        let currentDayIndexPath = IndexPath(row: currentDay - 1 + calendarView.monthDaysCollectionView.minimumSelectableItemRow, section: 0)
        
        calendarView.monthDaysCollectionView.selectItem(at: currentDayIndexPath, animated: true, scrollPosition: .centeredVertically)
        calendarView.collectionView(calendarView.monthDaysCollectionView, didSelectItemAt: currentDayIndexPath)
    }
    
    @objc func selectNextMonth() {
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
    
    @objc func selectPreviousMonth() {
        if selectedMonthIsFirstMonthInYear {
            guard !selectedYearIsFirstSelectableYear else {
                return
            }
            
            let newSelectedYearIndex = selectedYearIndex - 1
            handleYearSelection(selectedIndex: newSelectedYearIndex)
        }
        
        let newSelectedMonthIndex = selectedMonthIndex == 0 ? 11 : selectedMonthIndex - 1
        
        handleMonthSelection(selectedIndex: newSelectedMonthIndex)
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
        
        calendarView.updateMonthDaysModel(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: firstWeekDayNumber - 1)
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
