import UIKit

class CalendarView: UIView, UIGestureRecognizerDelegate {
	
    static let width = CGFloat(Int(LayoutConstants.screenWidth * 0.95) - (Int(LayoutConstants.screenWidth * 0.95) % 7))
    
	var monthDayCellModels: [MonthDayCellModel] = []
		
    let popoverCalendarBtnsRow = CalendarPopoverBtnsRow(frame: .zero)
    
    var selectedDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = PopoverBtn.defaultTintColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "من - إلى -"
        label.font = .systemFont(ofSize: PopoverBtn.fontSize)
        
        return label
    }()
	
	lazy var weekDayLabelsHorizontalStack: UIStackView = {
		let labels = createWeekDayLabels()
		
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
		collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = false
        
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(MonthDayCell.self, forCellWithReuseIdentifier: monthDayCellReuseIdentifier)
        
		return collectionView
	}()
	
    let monthDayCellReuseIdentifier = "monthDayCell"
    
    var allowsRangeSelection: Bool = false {
        didSet {
            monthDaysCollectionView.allowsMultipleSelection = allowsRangeSelection
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
        return popoverCalendarBtnsRow.calendarTypePopoverBtn
    }
    
    var monthPopoverBtn: PopoverBtn {
        return popoverCalendarBtnsRow.monthPopoverBtn
    }
    
    var yearPopoverBtn: PopoverBtn {
        return popoverCalendarBtnsRow.yearPopoverBtn
    }
    
    var calendarTypeLabel: String? {
        get {
            return calendarTypePopoverBtn.label.text
        }
        set {
            calendarTypePopoverBtn.label.text = newValue
        }
    }
    
    var monthLabel: String? {
        get {
            return monthPopoverBtn.label.text
        }
        set {
            monthPopoverBtn.label.text = newValue
        }
    }
    
    var yearLabel: String? {
        get {
            return yearPopoverBtn.label.text
        }
        set {
            yearPopoverBtn.label.text = newValue
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
		setupSubviews()
	}
	
	func setupSubviews() {
        setupPopoverCalendarBtnsRow()
        setupSelectedDaysLabel()
		setupWeekDayLabelsHorizontalStack()
		setupMonthDaysCollectionView()
	}
    
    func setupPopoverCalendarBtnsRow() {
        addSubview(popoverCalendarBtnsRow)
        popoverCalendarBtnsRow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popoverCalendarBtnsRow.topAnchor.constraint(equalTo: topAnchor),
            popoverCalendarBtnsRow.centerXAnchor.constraint(equalTo: centerXAnchor),
            popoverCalendarBtnsRow.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            popoverCalendarBtnsRow.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
	
    func setupSelectedDaysLabel() {
        addSubview(selectedDaysLabel)
        
        NSLayoutConstraint.activate([
            selectedDaysLabel.topAnchor.constraint(equalTo: popoverCalendarBtnsRow.bottomAnchor, constant: 10),
            selectedDaysLabel.leadingAnchor.constraint(equalTo: popoverCalendarBtnsRow.leadingAnchor),
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
    	
	func createWeekDayLabels() -> [UILabel] {
		var labels: [UILabel] = []
		
		for i in 0...6 {
			let weekDayLabel = UILabel(frame: .zero)
			
			weekDayLabel.text = WeekDayNames.arabicNames[i]
			weekDayLabel.textColor = .white
			weekDayLabel.font = .systemFont(ofSize: 13)
			weekDayLabel.textAlignment = .center
			
			labels.append(weekDayLabel)
		}
		
		return labels
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
		var models: [MonthDayCellModel] = []
		
		for i in 0...((numberOfDays - 1) + firstColumnNumber) {
			let dayNumber = i < firstColumnNumber ? 0 : (i - firstColumnNumber) + 1
			
			models.append(MonthDayCellModel(dayNumber: dayNumber, includesItem: false))
		}
		
		return models
	}
    
    func updateSelectedDaysLabel(firstDay: String, lastDay: String) {
        selectedDaysLabel.text = "من \(firstDay) إلى \(lastDay)"
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
                self.onLastItemLongPress()
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
    
    func onLastItemLongPress() {

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
