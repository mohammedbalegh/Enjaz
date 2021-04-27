import UIKit

class CalendarScreenVC: CalendarViewController {
    
    var currentMonthItems: [ItemModel] = []
    var currentWeekItems: [ItemModel] = []
        
    var dailyViewPopup = DailyViewPopup()
	lazy var itemCardPopup: ItemCardPopup = {
		let popup = ItemCardPopup()
		popup.itemsUpdateHandler = updateScreen
		return popup
	}()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
		// Present then dismiss the popup secretly, because first time the popup is presented the auto scroll doesn't work.
		secretlyPresentAndDismissDailyViewPopup()
		configureCalendarView()
		calendarView.weekDaysCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateScreen()
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
    
    func updateScreen() {
        updateMonthItems()
        updateWeekItems()
    }
	
	func secretlyPresentAndDismissDailyViewPopup() {
		dailyViewPopup.isHidden = true
		dailyViewPopup.popupDismissalHandler = {
			if self.dailyViewPopup.isHidden {
				self.dailyViewPopup.isHidden = false
			} else {
				// Whenever the popup is dismissed, insatiate a new popup object to reset its animation state.
				self.dailyViewPopup = DailyViewPopup()
				self.secretlyPresentAndDismissDailyViewPopup()
			}
		}
		
		dailyViewPopup.present(animated: true)
		dailyViewPopup.dismiss(animated: true)
	}
        
    func updateMonthItems() {
        let itemModels = RealmManager.retrieveItems()
        
        currentMonthItems = itemModels.filter { item in
            let itemDateComponents = DateAndTimeTools.getDateComponentsOf(unixTimeStamp: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            let selectedMonth = selectedMonthIndex + 1
            let selectedYear = currentYear + selectedYearIndex
            
            return itemDateComponents.year == selectedYear && itemDateComponents.month == selectedMonth
        }
        
        var itemsOfMonthDayRows: [Int: [ItemModel]] = [:]
        
        for item in currentMonthItems {
            let itemDateComponents = DateAndTimeTools.getDateComponentsOf(unixTimeStamp: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            
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
            let itemDateComponents = DateAndTimeTools.getDateComponentsOf(unixTimeStamp: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            return (calendarView.firstWeekDayNumber...calendarView.lastWeekDayNumber) ~= itemDateComponents.day ?? -1
        }
        
        var itemsOfWeekDayRows: [Int: [ItemModel]] = [:]
        
        for item in currentWeekItems {
            let itemDateComponents = DateAndTimeTools.getDateComponentsOf(unixTimeStamp: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            
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
    
    func getIncludedItemsForMonthDays() -> [[ItemModel]] {
        var monthDaysIncludedItems: [[ItemModel]] = []
        
        for monthDayCellModel in calendarView.monthDayCellModels {
            guard monthDayCellModel.dayNumber != 0 else { continue }
            
            monthDaysIncludedItems.append(monthDayCellModel.includedItems)
        }
                
        return monthDaysIncludedItems
    }
    
	func handleDailyViewItemTap(items: [ItemModel]) {
		itemCardPopup.itemModels = items
		itemCardPopup.present(animated: true)
	}
	
	func handleItemAdditionContextMenuAction(type: ItemType, unixTimeStamp: Double?) {
		let addItemScreenVC = AddItemScreenVC()
		
		addItemScreenVC.itemType = type.id
		addItemScreenVC.delegate = self
		
		if let unixTimeStamp = unixTimeStamp {
			let readableDate = DateAndTimeTools.getReadableDate(from: Date(timeIntervalSince1970: unixTimeStamp), withFormat: "hh:00 aa | dd MMMM yyyy", calendarIdentifier: selectedCalendarIdentifier)
			addItemScreenVC.handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: [unixTimeStamp], readableDate: readableDate)
		}
		
		navigationController?.present(addItemScreenVC, animated: true)
	}
    
}

extension CalendarScreenVC: CalendarViewDelegate {
    func calendarCollectionView(_ calendarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let weeklyViewIsShown = selectedViewTypeIndex == 1
        if weeklyViewIsShown {
            let cell = calendarCollectionView.cellForItem(at: indexPath) as? WeekDayCell
			guard let itemModels = cell?.viewModel?.includedItems, !itemModels.isEmpty else { return }
            itemCardPopup.itemModels = itemModels
            itemCardPopup.present(animated: true)
            return
        }
        
        calendarCollectionView.deselectAllItems(animated: false)
        
        dailyViewPopup.selectedMonth = selectedMonthIndex + 1
        dailyViewPopup.selectedYear = currentYear + selectedYearIndex
        dailyViewPopup.selectedDay = calendarView.monthDayCellModels[indexPath.row].dayNumber
        dailyViewPopup.selectedCalendarIdentifier = selectedCalendarIdentifier
        dailyViewPopup.monthDaysIncludedItems = getIncludedItemsForMonthDays()
		dailyViewPopup.itemSelectionHandler = handleDailyViewItemTap
		dailyViewPopup.itemAdditionContextMenuActionHandler = handleItemAdditionContextMenuAction
		
        dailyViewPopup.present(animated: true)
    }
}

extension CalendarScreenVC: AddItemScreenDelegate {
	func didAddItem(_ modalScreen: UIViewController) {
		updateScreen()
		dailyViewPopup.monthDaysIncludedItems = getIncludedItemsForMonthDays()
	}
}
