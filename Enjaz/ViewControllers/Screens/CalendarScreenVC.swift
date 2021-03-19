import UIKit

class CalendarScreenVC: CalendarViewController {
    
    var currentMonthItems: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        
        calendarView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateItems()
    }
    
    // MARK: Tools
    
    override func getCalendarViewPopoverBtnsRow() -> CalendarPopoverBtnsRow {
        return CalendarPopoverBtnsRow(firstBtn: .calendarType, secondBtn: .viewType)
    }
    
    override func updateMonthDays() {
        super.updateMonthDays()
        updateItems()
    }
        
    func updateItems() {
        let itemModels = RealmManager.retrieveItems()
        
        currentMonthItems = itemModels.filter { item in
            let itemDateComponents = DateAndTimeTools.getComponentsOfUnixTimeStampDate(timeIntervalSince1970: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            let selectedMonth = selectedMonthIndex + 1
            
            return itemDateComponents.month == selectedMonth
        }
        
        let itemRowsInMonthDaysCollectionViews = currentMonthItems.map { item -> Int in
            let itemDateComponents = DateAndTimeTools.getComponentsOfUnixTimeStampDate(timeIntervalSince1970: item.date, forCalendarIdentifier: selectedCalendarIdentifier)
            guard let itemDay = itemDateComponents.day else { return -1 }
            
            return itemDay + calendarView.minimumSelectableItemRow - 1
        }
        calendarView.updateMonthDaysModelWithDueItems(itemRowsInMonthDaysCollectionViews: itemRowsInMonthDaysCollectionViews)
    }
    
}

extension CalendarScreenVC: CalendarViewDelegate {
    func calendarCollectionView(_ calendarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        calendarCollectionView.deselectAllItems(animated: false)
        
        for index in calendarView.monthDayCellModels[indexPath.row].includedItemsIndices {
            print(currentMonthItems[index])
        }
    }
}
