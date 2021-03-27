import UIKit

class CalendarScreenVC: CalendarViewController {
    
    var currentMonthItems: [ItemModel] = []
    var currentWeekItems: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        
        configureCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateItems()
    }
    
    // MARK: Tools
        
    override func configureCalendarPopoverBtnsRow(calendarPopoverBtnsRow: CalendarPopoverBtnsRow) {
        calendarPopoverBtnsRow.configureWithBtns(firstBtn: .calendarType, secondBtn: .viewType)
    }
    
    func configureCalendarView() {
        calendarView.delegate = self
        calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 35).isActive = true
        calendarView.weekDaysCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight + 35, right: 0)
    }
    
    override func updateMonthDays() {
        super.updateMonthDays()
        updateMonthItems()
    }
        
    override func handleWeekSelection(selectedIndex: Int) {
        super.handleWeekSelection(selectedIndex: selectedIndex)
        updateWeekItems()
    }
    
    func updateItems() {
        updateMonthItems()
        updateWeekItems()
    }
        
    func updateMonthItems() {
        let itemModels = RealmManager.retrieveItems()
        
        currentMonthItems = itemModels.filter { item in
            let itemDateComponents = DateAndTimeTools.getComponentsOfUnixTimeStampDate(timeIntervalSince1970: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            let selectedMonth = selectedMonthIndex + 1
            let selectedYear = currentYear + selectedYearIndex
            
            return itemDateComponents.year == selectedYear && itemDateComponents.month == selectedMonth
        }
        
        var itemsOfMonthDayRows: [Int: [ItemModel]] = [:]
        
        for item in currentMonthItems {
            let itemDateComponents = DateAndTimeTools.getComponentsOfUnixTimeStampDate(timeIntervalSince1970: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            
            guard let itemDay = itemDateComponents.day else { continue }
            
            let itemRow = itemDay + calendarView.minimumSelectableItemRow - 1
            
            if itemsOfMonthDayRows[itemRow] == nil {
                itemsOfMonthDayRows[itemRow] = [item]
            } else {
                itemsOfMonthDayRows[itemRow]!.append(item)
            }
        }
        
        calendarView.updateMonthDaysModelWithDueItems(itemsOfMonthDayRows: itemsOfMonthDayRows)
    }
    
    func updateWeekItems() {
        currentWeekItems = currentMonthItems.filter { item in
            let itemDateComponents = DateAndTimeTools.getComponentsOfUnixTimeStampDate(timeIntervalSince1970: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            return (calendarView.firstWeekDayNumber...calendarView.lastWeekDayNumber) ~= itemDateComponents.day ?? -1
        }
        
        var itemsOfWeekDayRows: [Int: [ItemModel]] = [:]
        
        for item in currentWeekItems {
            let itemDateComponents = DateAndTimeTools.getComponentsOfUnixTimeStampDate(timeIntervalSince1970: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            
            guard let itemDay = itemDateComponents.day, let itemHour = itemDateComponents.hour else { continue }
            
            let weekDayIndex = itemDay - calendarView.firstWeekDayNumber
            
            let itemRow = calendarView.getWeekDayCellRowBy(weekDayIndex: weekDayIndex, andHour: itemHour)
            
            if itemsOfWeekDayRows[itemRow] == nil {
                itemsOfWeekDayRows[itemRow] = [item]
            } else {
                itemsOfWeekDayRows[itemRow]!.append(item)
            }
        }
        
        calendarView.updateWeekDaysModelWithDueItems(itemsOfWeekDayRows: itemsOfWeekDayRows)
    }
        
}

extension CalendarScreenVC: CalendarViewDelegate {
    func calendarCollectionView(_ calendarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedViewTypeIndex == 1 { return }
        calendarCollectionView.deselectAllItems(animated: false)
        
        for item in (calendarCollectionView.cellForItem(at: indexPath) as! MonthDayCell).viewModel?.includedItems ?? [] {
            print(item)
        }
    }
}
