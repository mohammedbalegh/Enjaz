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
		dailyView.dismissBtn = dismissBtn
		
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
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		keyWindow?.rootViewController?.view.addSubview(self)
		
		prepareForPresentation(animated)
		
		if animated {
			animateContentViewIn()
		} else {
			contentView.alpha = 1
		}
	}
		    
    func setupDailyView() {
        contentView.addSubview(dailyView)
        dailyView.fillSuperView()
    }
	
	override func setupSubViews() {
		super.setupSubViews()
		setupDailyView()
	}
	
	override func setupContentView() {
		contentView.backgroundColor = .none
		let height = ZoomAndSnapFlowLayout.itemSize.height * (1 + ZoomAndSnapFlowLayout.zoomFactor)
		
		NSLayoutConstraint.activate([
			contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
			contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
			contentView.heightAnchor.constraint(equalToConstant: height),
		])
	}
	
}
