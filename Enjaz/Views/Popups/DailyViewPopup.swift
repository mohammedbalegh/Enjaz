import UIKit

class DailyViewPopup: Popup {
    	
    var monthDaysIncludedItems: [[ItemModel]] = [] {
        didSet {
            dailyView.monthDaysIncludedItems = monthDaysIncludedItems
        }
    }
    
    let dailyView = DailyView()
    
    var selectedDay = 1 {
        didSet {
            dailyView.selectedDay = selectedDay
        }
    }
    
    var selectedMonth = 1 {
        didSet {
            dailyView.selectedMonth = selectedMonth
        }
    }
    
    var selectedYear = 1 {
        didSet {
            dailyView.selectedYear = selectedYear
        }
    }
    
    var selectedCalendarIdentifier = Calendar.current.identifier {
        didSet {
            dailyView.selectedCalendarIdentifier = selectedCalendarIdentifier
        }
    }
	
	var itemSelectionHandler: ((_ selectedItem: [ItemModel]) -> Void)? {
		didSet {
			dailyView.itemSelectionHandler = itemSelectionHandler
		}
	}
	
	var selectedItem: ItemModel?
	
    override func popupContainerDidShow() {
        setupDailyView()
    }
	
	override func present() {
		super.present()
//		selectedItem = nil
	}
	    
    override func setupPopupContainer() {
        popupContainer.backgroundColor = .none
        let height = ZoomAndSnapFlowLayout.itemSize.height * (1 + ZoomAndSnapFlowLayout.zoomFactor)
        
        NSLayoutConstraint.activate([
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            popupContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            popupContainer.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    func setupDailyView() {
        popupContainer.addSubview(dailyView)
        dailyView.fillSuperView()
    }
}
