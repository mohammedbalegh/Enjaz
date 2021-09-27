import UIKit

class DailyView: UIView {
    let dailyViewCellReuseIdentifier = "dailyViewCell"
	var dailyViewDayModels: [DailyViewDayModel] = Array(repeating: DailyViewDayModel(dayNumber: 0, month: 0, year: 0, calendarIdentifier: Calendar.current.identifier, weekDayName: "", includedItems: []), count: 31)
    
    lazy var carouselCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ZoomAndSnapFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(DailyViewCell.self, forCellWithReuseIdentifier: dailyViewCellReuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    var selectedDay = 1
    var selectedMonth = 1
    var selectedYear = 1
    var selectedCalendarIdentifier = Calendar.current.identifier
	
	var itemSelectionHandler: ((_ selectedItem: [ItemModel]) -> Void)?
	var itemAdditionContextMenuActionHandler: ((_ type: ItemType, _ unixTimeStamp: Double?) -> Void)?
	var dismiss: ((_ animated: Bool) -> Void)?
	var blurOverlay: UIVisualEffectView?
	var dismissBtn: UIButton?
		
	var selectedCellIndexPath: IndexPath {
		return IndexPath(row: selectedDay - 1, section: 0)
	}
    
    var monthDaysIncludedItems: [[ItemModel]] = [] {
        didSet {
            dailyViewDayModels = generateDailyViewDayModels(monthDaysIncludedItems: monthDaysIncludedItems)
			carouselCollectionView.reloadData()
			
			DispatchQueue.main.async {
				self.carouselCollectionView.scrollToItem(at: self.selectedCellIndexPath, at: .centeredHorizontally, animated: false)
			}
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCarouselCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    func setupCarouselCollectionView() {
        addSubview(carouselCollectionView)
        carouselCollectionView.fillSuperView()
    }
    
    func generateDailyViewDayModels(monthDaysIncludedItems: [[ItemModel]]) -> [DailyViewDayModel] {
		let updatedDailyViewDayModels = monthDaysIncludedItems.enumerated().map { (index, includedItems) -> DailyViewDayModel in
            let day = index + 1
            let calendar = Calendar(identifier: selectedCalendarIdentifier)
            
            let date = Date.generateDateObjectFromComponents(year: selectedYear, month: selectedMonth, day: day, hour: 12, calendarIdentifier: selectedCalendarIdentifier)
            
            let weekdayNumber = calendar.component(.weekday, from: date)
            let weekdayName = calendar.weekdaySymbols[weekdayNumber - 1]
            
			let dailyViewDayModel = DailyViewDayModel(dayNumber: day, month: selectedMonth, year: selectedYear, calendarIdentifier: selectedCalendarIdentifier, weekDayName: weekdayName, includedItems: includedItems)
                        
            return dailyViewDayModel
        }
        
        return updatedDailyViewDayModels
    }
    
}

extension DailyView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyViewDayModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dailyViewCellReuseIdentifier, for: indexPath) as! DailyViewCell
		
        cell.viewModel = dailyViewDayModels[indexPath.row]
		
		cell.itemSelectionHandler = itemSelectionHandler
		cell.itemAdditionContextMenuActionHandler = itemAdditionContextMenuActionHandler
		cell.dismissPopup = dismiss
		cell.blurOverlay = blurOverlay
		cell.dismissBtn = dismissBtn
		
        return cell
    }
    
}
