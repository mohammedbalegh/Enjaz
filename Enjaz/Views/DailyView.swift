import UIKit

class DailyView: UIView {
    let dailyViewCellReuseIdentifier = "dailyViewCell"
    var dailyViewDayModels: [DailyViewDayModel] = Array(repeating: DailyViewDayModel(dayNumber: 0, weekDayName: "", includedItems: []), count: 31)
    
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
    
    var monthDaysIncludedItems: [[ItemModel]] = [] {
        didSet {
            dailyViewDayModels = generateDailyViewDayModels(monthDaysIncludedItems: monthDaysIncludedItems)
            carouselCollectionView.reloadData()
			
			let selectedCellIndexPath = IndexPath(row: selectedDay - 1, section: 0)
            carouselCollectionView.scrollToItem(at: selectedCellIndexPath, at: .centeredHorizontally, animated: false)
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
        var index = 0
        let updatedDailyViewDayModels = monthDaysIncludedItems.map { includedItems -> DailyViewDayModel in
            let day = index + 1
            let calendar = Calendar(identifier: selectedCalendarIdentifier)
            
            let date = DateAndTimeTools.generateDateObjectFromComponents(year: selectedYear, month: selectedMonth, day: day, hour: 12, calendarIdentifier: selectedCalendarIdentifier)
            
            let weekdayNumber = calendar.component(.weekday, from: date)
            let weekdayName = calendar.weekdaySymbols[weekdayNumber - 1]
            
            let dailyViewDayModel = DailyViewDayModel(dayNumber: day, weekDayName: weekdayName, includedItems: includedItems)
            
            index += 1
            
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
        return cell
    }
    
}
