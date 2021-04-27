import UIKit

class DailyViewPopup: Popup {
    	
    var monthDaysIncludedItems: [[ItemModel]] = [] {
        didSet {
            dailyView.monthDaysIncludedItems = monthDaysIncludedItems
        }
    }
    
	lazy var dailyView: DailyView = {
		let dailyView = DailyView()
		dailyView.translatesAutoresizingMaskIntoConstraints = false
		
		dailyView.dismiss = dismiss
		dailyView.blurOverlay = blurOverlay
		
		return dailyView
	}()
    
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
	
	var itemAdditionContextMenuActionHandler: ((_ type: ItemType, _ unixTimeStamp: Double?) -> Void)? {
		didSet {
			dailyView.itemAdditionContextMenuActionHandler = itemAdditionContextMenuActionHandler
		}
	}
	
	override func present(animated: Bool) {
		let window = UIApplication.shared.windows[0]
		window.rootViewController?.view.addSubview(self)
		
		prepareForPresentation(animated)
		
		if animated {
			animatePopupContainerIn()
		} else {
			popupContainer.alpha = 1
		}
	}
		    
    func setupDailyView() {
        popupContainer.addSubview(dailyView)
        dailyView.fillSuperView()
    }
	
	override func setupSubViews() {
		super.setupSubViews()
		setupDailyView()
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
	
}
