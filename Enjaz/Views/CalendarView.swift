import UIKit

class CalendarView: UIView, UIGestureRecognizerDelegate {
	
    static let width = CGFloat(Int(LayoutConstants.screenWidth * 0.95) - (Int(LayoutConstants.screenWidth * 0.95) % 7))
    
	var monthDayCellModels: [MonthDayCellModel] = []
    
    var calendarPopoverBtnsRow = CalendarPopoverBtnsRow(firstBtn: nil, secondBtn: nil, thirdBtn: nil)
    
    let monthSwitcher = MonthSwitcher()
    
    let selectedDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = PopoverBtn.defaultTintColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = NSLocalizedString("from", comment: "") + " - " + NSLocalizedString("to", comment: "") + " -"
        label.font = .systemFont(ofSize: PopoverBtn.fontSize)
        label.isHidden = true
        
        return label
    }()
	
	lazy var weekDayLabelsHorizontalStack: UIStackView = {
		let labels = generateWeekDayLabels()
		
		let stackView = UIStackView(arrangedSubviews: labels)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.alignment = .center
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	lazy var monthDaysCollectionView: MultipleCellSelectionCollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.sectionHeadersPinToVisibleBounds = true
        let layoutItemWidth = CalendarView.width / 7
        layout.itemSize = CGSize(width: layoutItemWidth, height: (layoutItemWidth * 0.8).rounded())
		
		// Collection View
		let collectionView = MultipleCellSelectionCollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.clipsToBounds = true
		collectionView.backgroundColor = .none
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(MonthDayCell.self, forCellWithReuseIdentifier: monthDayCellReuseIdentifier)
        
		return collectionView
	}()
	
    let monthDayCellReuseIdentifier = "monthDayCell"
    
    var allowsRangeSelection: Bool = false {
        didSet {
            monthDaysCollectionView.allowsMultipleSelection = allowsRangeSelection
            selectedDaysLabel.isHidden = !allowsRangeSelection
        }
    }
        
    var delegate: CalendarViewDelegate?
    
	// MARK: State
    
	var selectedMonthDayItemRow: Int?
    var firstSelectedMonthDayItemRow: Int?
    var lastSelectedMonthDayItemRow: Int?
    
    var isLongPressingOnLastItem = false
    
    var selectionGestureIsSwitchingToNextMonth: Bool = false
    var currentSelectionIsAcrossMultipleMonths: Bool = false
    var selectedMonthIsLastSelectableMonth: Bool = false
    
    var selectedDay: Int {
        return monthDayCellModels[selectedMonthDayItemRow ?? 0].dayNumber
    }
    
    var firstSelectedDay: Int {
        return monthDayCellModels[firstSelectedMonthDayItemRow ?? 0].dayNumber
    }
    
    var lastSelectedDay: Int {
        return monthDayCellModels[lastSelectedMonthDayItemRow ?? 0].dayNumber
    }
    
    var calendarTypePopoverBtn: PopoverBtn {
        return calendarPopoverBtnsRow.calendarTypePopoverBtn
    }
    
    var monthPopoverBtn: PopoverBtn {
        return calendarPopoverBtnsRow.monthPopoverBtn
    }
    
    var yearPopoverBtn: PopoverBtn {
        return calendarPopoverBtnsRow.yearPopoverBtn
    }
    
    var viewTypePopoverBtn: PopoverBtn {
        return calendarPopoverBtnsRow.viewTypePopoverBtn
    }
    
    var nextMonthBtn: UIButton {
        return monthSwitcher.nextMonthBtn
    }
    
    var previousMonthBtn: UIButton {
        return monthSwitcher.previousMonthBtn
    }
    
    var calendarTypeLabel: String? {
        get {
            return calendarTypePopoverBtn.label.text
        }
        set {
            calendarTypePopoverBtn.label.text = newValue
        }
    }
    
    var viewTypeLabel: String? {
        get {
            return viewTypePopoverBtn.label.text
        }
        set {
            viewTypePopoverBtn.label.text = newValue
        }
    }
    
    var selectedMonthLabel: String? {
        get {
            return monthPopoverBtn.label.text
        }
        set {
            monthSwitcher.selectedMonthLabel.text = newValue
            monthPopoverBtn.label.text = newValue
        }
    }
    
    var selectedYearLabel: String? {
        get {
            return yearPopoverBtn.label.text
        }
        set {
            monthSwitcher.selectedYearLabel.text = newValue
            yearPopoverBtn.label.text = newValue
        }
    }
    
    var minimumSelectableItemRow: Int {
        get {
            return monthDaysCollectionView.minimumSelectableItemRow
        }
    }
    
	init() {
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: View Setups
	
	override func layoutSubviews() {
        super.layoutSubviews()
        setupMonthSwitcher()
        setupPopoverCalendarBtnsRow()
        setupSelectedDaysLabel()
        setupWeekDayLabelsHorizontalStack()
        setupMonthDaysCollectionView()
	}
    
    func setupMonthSwitcher() {
        addSubview(monthSwitcher)
        monthSwitcher.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthSwitcher.topAnchor.constraint(equalTo: topAnchor),
            monthSwitcher.centerXAnchor.constraint(equalTo: centerXAnchor),
            monthSwitcher.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            monthSwitcher.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])
    }
	    
    func setupPopoverCalendarBtnsRow() {
        addSubview(calendarPopoverBtnsRow)
        calendarPopoverBtnsRow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarPopoverBtnsRow.topAnchor.constraint(equalTo: monthSwitcher.bottomAnchor, constant: 15),
            calendarPopoverBtnsRow.centerXAnchor.constraint(equalTo: centerXAnchor),
            calendarPopoverBtnsRow.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            calendarPopoverBtnsRow.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
	
    func setupSelectedDaysLabel() {
        addSubview(selectedDaysLabel)
        
        NSLayoutConstraint.activate([
            selectedDaysLabel.topAnchor.constraint(equalTo: calendarPopoverBtnsRow.bottomAnchor, constant: 10),
            selectedDaysLabel.leadingAnchor.constraint(equalTo: calendarPopoverBtnsRow.leadingAnchor),
            selectedDaysLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            selectedDaysLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 40),
        ])
    }
    
	func setupWeekDayLabelsHorizontalStack() {
		addSubview(weekDayLabelsHorizontalStack)
		
        let height: CGFloat = max(LayoutConstants.screenHeight * 0.065, 45)
		weekDayLabelsHorizontalStack.layer.cornerRadius = height / 2
		
		NSLayoutConstraint.activate([
            weekDayLabelsHorizontalStack.topAnchor.constraint(equalTo: selectedDaysLabel.bottomAnchor, constant: 20),
			weekDayLabelsHorizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
			weekDayLabelsHorizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
			weekDayLabelsHorizontalStack.heightAnchor.constraint(equalToConstant: height),
		])
		
		weekDayLabelsHorizontalStack.applyAccentColorGradient(size: CGSize(width: CalendarView.width, height: height), cornerRadius: weekDayLabelsHorizontalStack.layer.cornerRadius)
	}
	
	func setupMonthDaysCollectionView() {
		addSubview(monthDaysCollectionView)
		
		monthDaysCollectionView.isUserInteractionEnabled = true
        
		NSLayoutConstraint.activate([
			monthDaysCollectionView.topAnchor.constraint(equalTo: weekDayLabelsHorizontalStack.bottomAnchor, constant: 5),
			monthDaysCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            monthDaysCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            monthDaysCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
	}
	
	// MARK: Tools
    
    func generateWeekDayLabels() -> [UILabel] {
		var labels: [UILabel] = []
		
        let formatter = DateFormatter()
        let weekDayNames = formatter.shortWeekdaySymbols ?? []
        let islamicallyWeekDayNames = sortWeekDayNamesIslamically(weekDayNames)
        
		for weekDayName in islamicallyWeekDayNames {
			let weekDayLabel = UILabel(frame: .zero)
            
			weekDayLabel.text = weekDayName
			weekDayLabel.textColor = .white
			weekDayLabel.font = .systemFont(ofSize: 13)
			weekDayLabel.textAlignment = .center
			
			labels.append(weekDayLabel)
		}
		
		return labels
	}
    
    func sortWeekDayNamesIslamically(_ weekDayNames: [String]) -> [String] {
        return [weekDayNames[6]] + weekDayNames.dropLast()
    }
	
	func updateMonthDaysModel(numberOfDaysInMonth: Int, startsAtColumnNumber firstColumn: Int) {
		monthDayCellModels = generateMonthDaysCellModels(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: firstColumn)
        monthDaysCollectionView.minimumSelectableItemRow = firstColumn
        selectedMonthDayItemRow = nil
        monthDaysCollectionView.deselectAllItems(animated: true)
        
        if selectionGestureIsSwitchingToNextMonth {
            monthDaysCollectionView.firstSelectedItemIndexPath = IndexPath(row: monthDaysCollectionView.minimumSelectableItemRow, section: 0)
        }
        
		monthDaysCollectionView.reloadData()
	}
    	
	func generateMonthDaysCellModels(numberOfDaysInMonth numberOfDays: Int, startsAtColumnNumber firstColumnNumber: Int) -> [MonthDayCellModel] {
        let dayNumbers = Array(repeating: 0, count: firstColumnNumber) + (1...numberOfDays)
        let monthDayCellModels: [MonthDayCellModel] = dayNumbers.map {
            MonthDayCellModel(dayNumber: $0, includedItemsIndices: [])
        }
        
        return monthDayCellModels
	}
    
    
    func updateMonthDaysModelWithDueItems(itemRowsInMonthDaysCollectionViews: [Int]) {
        guard !itemRowsInMonthDaysCollectionViews.isEmpty else { return }
        
        resetMonthDayCellModelsIncludedItems()
        
        for i in 0...itemRowsInMonthDaysCollectionViews.count - 1 {
            let itemRow = itemRowsInMonthDaysCollectionViews[i]
            monthDayCellModels[itemRow].includedItemsIndices.append(i)
        }
        
        monthDaysCollectionView.reloadData()
    }
    
    func resetMonthDayCellModelsIncludedItems() {
        monthDayCellModels = monthDayCellModels.map { monthDayCellModel in
            var updatedMonthDayCellModel = monthDayCellModel
            updatedMonthDayCellModel.includedItemsIndices = []
            return updatedMonthDayCellModel
        }
    }
    
    func updateSelectedDaysLabel(firstDay: String, lastDay: String) {
        selectedDaysLabel.text = "\(NSLocalizedString("from", comment: "")) \(firstDay) \(NSLocalizedString("to", comment: "")) \(lastDay)"
    }
}


extension CalendarView: MultipleCellSelectionCollectionViewDelegate, UICollectionViewDataSource {
		
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return monthDayCellModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: monthDayCellReuseIdentifier, for: indexPath) as! MonthDayCell
		
		cell.viewModel = monthDayCellModels[indexPath.row]
        
		return cell
	}
    
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedMonthDayItemRow = indexPath.row
        collectionView.deselectAllItemsExceptAt(indexPath, animated: true)
        delegate?.calendarCollectionView(collectionView, didSelectItemAt: indexPath)
	}
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: MultipleCellSelectionCollectionView, didSelectItemAt indexPath: IndexPath, startedSelectionAt firstSelectedItemIndexPath: IndexPath) {
        guard !selectionGestureIsSwitchingToNextMonth else {
            selectionGestureIsSwitchingToNextMonth = false
            self.collectionView(collectionView, didSelectItemAt: indexPath, startedSelectionAt: collectionView.firstSelectedItemIndexPath!)
            return
        }
        
        let lowerRowBound = min(indexPath.row, firstSelectedItemIndexPath.row)
        let upperRowBound = max(indexPath.row, firstSelectedItemIndexPath.row)
                
        let lowerBoundCell = monthDaysCollectionView.cellForItem(at: IndexPath(row: lowerRowBound, section: 0))
        let upperBoundCell = monthDaysCollectionView.cellForItem(at: IndexPath(row: upperRowBound, section: 0))
        
        lowerBoundCell?.roundCorners([.topLeading, .bottomLeading])
        upperBoundCell?.roundCorners([.topTrailing, .bottomTrailing])
        
        highlightItemsInsideTheBounds(lowerRowBound  + 1, upperRowBound - 1)
        
        if firstSelectedMonthDayItemRow == nil {
            firstSelectedMonthDayItemRow = firstSelectedItemIndexPath.row
            delegate?.didUpdateFirstSelectedMonthDayItemRow(self)
        }
        
        lastSelectedMonthDayItemRow = indexPath.row
        delegate?.didUpdateLastSelectedMonthDayItemRow(self)
        
        let lastSelectedMonthDayItemIsLastItem = indexPath.row == monthDayCellModels.count - 1
        
        if lastSelectedMonthDayItemIsLastItem {
            isLongPressingOnLastItem = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard self.isLongPressingOnLastItem else { return }
                self.handleLastItemLongPress()
                self.isLongPressingOnLastItem = false
           }
        } else {
            isLongPressingOnLastItem = false
        }
    }
    
    func didEndMultipleSelection(_ collectionView: MultipleCellSelectionCollectionView) {
        firstSelectedMonthDayItemRow = nil
        selectionGestureIsSwitchingToNextMonth = false
        currentSelectionIsAcrossMultipleMonths = false
        isLongPressingOnLastItem = false
    }
    
    // MARK: Tools
    
    func highlightItemsInsideTheBounds(_ lowerRowBound: Int, _ upperRowBound: Int) {
        guard let indexPathsForSelectedItems = monthDaysCollectionView.indexPathsForSelectedItems else {
            return
        }
        
        indexPathsForSelectedItems.forEach { selectedItemIndexPath in
            let cell = monthDaysCollectionView.cellForItem(at: selectedItemIndexPath) as? MonthDayCell
            
            if selectedItemIndexPath.row == lowerRowBound - 1 && currentSelectionIsAcrossMultipleMonths {
                cell?.isBetweenSelectionBounds = true
            } else if upperRowBound >= lowerRowBound && (lowerRowBound...upperRowBound) ~= selectedItemIndexPath.row {
                cell?.isBetweenSelectionBounds = true
            } else {
                cell?.backgroundColor = indexPathsForSelectedItems.count > 1 ? UIColor.accentColor.withAlphaComponent(0.2) : .clear
                cell?.isBetweenSelectionBounds = false
            }
        }
    }
    
    func handleLastItemLongPress() {

        guard !selectedMonthIsLastSelectableMonth else {
            monthDaysCollectionView.fadeOutAndIn(withDuration: 0.3)
            Vibration.error.vibrate()
            return
        }
        
        func midAnimationCompletionHandler(_: Bool) {
            self.selectionGestureIsSwitchingToNextMonth = true
            self.currentSelectionIsAcrossMultipleMonths = true
            self.delegate?.didLongPressOnLastItemDuringMultipleSelection(self)
        }
        
        monthDaysCollectionView.translateHorizontallyOutAndInSuperView(withDuration: 0.3, atDirection: .trailingToLeading, fadeOutAndIn: true, midAnimationCompletionHandler: midAnimationCompletionHandler)
    }
    
}
