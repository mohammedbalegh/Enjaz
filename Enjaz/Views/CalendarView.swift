import UIKit

class CalendarView: UIView, UIGestureRecognizerDelegate {
        
    static let width = CGFloat(Int(LayoutConstants.screenWidth * 0.95) - (Int(LayoutConstants.screenWidth * 0.95) % 7))
    
    var monthDayCellModels: [MonthDayCellModel] = []
    var weekDayCellModels: [WeekDayCellModel] = []
    
    var weekDaysNumbers: [[String]] = []
    
    let monthDayCellReuseIdentifier = "monthDayCell"
    let weekDayCellReuseIdentifier = "weekDayCell"
    
    var calendarPopoverBtnsRow = CalendarPopoverBtnsRow()
    
    let monthSwitcher = Switcher()
    let weekSwitcher = Switcher()
        
    let selectedDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = PopoverBtn.defaultTintColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isHidden = true
        
        return label
    }()
    
    let calendarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        return view
    }()
    
    let weekDayLabelsStackView = WeekDayLabelsStackView()
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MonthDayCell.self, forCellWithReuseIdentifier: monthDayCellReuseIdentifier)
        
        return collectionView
    }()
    
    lazy var weekDaysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let layoutItemWidth = CalendarView.width / 7
        layout.itemSize = CGSize(width: layoutItemWidth, height: layoutItemWidth)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(WeekDayCell.self, forCellWithReuseIdentifier: weekDayCellReuseIdentifier)
        
        return collectionView
    }()
    
    var selectedDaysLabelHeightConstraint: NSLayoutConstraint!
    
    var allowsRangeSelection = false {
        didSet {
            monthDaysCollectionView.allowsMultipleSelection = allowsRangeSelection
            selectedDaysLabel.isHidden = !allowsRangeSelection
            selectedDaysLabelHeightConstraint.constant = allowsRangeSelection ? 30 : 0
        }
    }
    
    var delegate: CalendarViewDelegate?
        
    var selectedMonthDayItemRow: Int?
    var firstSelectedMonthDayItemRow: Int?
    var lastSelectedMonthDayItemRow: Int?
    
    var isLongPressingOnLastItem = false
    
    var selectionGestureIsSwitchingToNextMonth: Bool = false
    var currentSelectionIsAcrossMultipleMonths: Bool = false
    var selectedMonthIsLastSelectableMonth: Bool = false
    
    var showInWeeklyView = false {
        didSet {
            calendarContainer.animateTwoConsecutiveAnimations(
                withDuration: 0.3,
                firstAnimation: {
					self.calendarContainer.alpha = 0
					self.calendarContainer.scale(to: 0.85)
				},
                secondAnimation: {
					self.calendarContainer.alpha = 1
					self.calendarContainer.scale(to: 1)
				},
                midAnimationCompletionHandler: {_ in
                    self.weekDaysCollectionView.isHidden = !self.showInWeeklyView
                    self.monthDaysCollectionView.isHidden = !self.weekDaysCollectionView.isHidden
                    self.weekSwitcher.isHidden = self.weekDaysCollectionView.isHidden
                    self.monthSwitcher.isHidden = self.monthDaysCollectionView.isHidden
                    
                    if self.showInWeeklyView {
                        self.weekDayLabelsStackView.showWeekDayNumbers()
                        self.weekDayLabelsStackView.spacing = 15
                        self.calendarContainer.backgroundColor = .tertiaryBackground
                    } else {
                        self.weekDayLabelsStackView.hideWeekDayNumbers()
                        self.weekDayLabelsStackView.spacing = 0
                        self.calendarContainer.backgroundColor = .none
                    }
                }
            )
        }
    }
    
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
	
	lazy var partitionsNumberPopoverBtn: PopoverBtn = {
		let button = PopoverBtn(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.configure(withSize: .small)
		button.label.font = .systemFont(ofSize: CalendarPopoverBtnsRow.popoverBtnsRowFontSize)
		button.isHidden = true
		
		return button
	}()
	
    var nextMonthBtn: UIButton {
        return monthSwitcher.nextBtn
    }
    
    var previousMonthBtn: UIButton {
        return monthSwitcher.previousBtn
    }
    
    var nextWeekBtn: UIButton {
        return weekSwitcher.nextBtn
    }
    
    var previousWeekBtn: UIButton {
        return weekSwitcher.previousBtn
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
	
	var partitionsNumberLabel: String? {
		get {
			return partitionsNumberPopoverBtn.label.text
		}
		set {
			partitionsNumberPopoverBtn.label.text = newValue
		}
	}
    
    var selectedWeekLabel: String? {
        get {
            return weekSwitcher.label.text
        }
        set {
            weekSwitcher.label.text = newValue
        }
    }
    
    var selectedMonthLabel: String? {
        get {
            return monthPopoverBtn.label.text
        }
        set {
            monthSwitcher.label.text = newValue
            weekSwitcher.secondaryLabel.text = newValue
            monthPopoverBtn.label.text = newValue
        }
    }
    
    var selectedYearLabel: String? {
        get {
            return yearPopoverBtn.label.text
        }
        set {
            monthSwitcher.secondaryLabel.text = newValue
            yearPopoverBtn.label.text = newValue
        }
    }
    
    var minimumSelectableItemRow: Int {
        get {
            return monthDaysCollectionView.minimumSelectableItemRow
        }
    }
    
    var firstWeekDayNumber: Int = 0
    var lastWeekDayNumber: Int = 0
    
    var firstWeekDayColumnIndex: Int = 0
    var lastWeekDayColumnIndex: Int = 0
    
    let hourLabels = Date.twelveHourFormatHourLabels
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Setups
    
    func setupSubviews() {
        setupMonthSwitcher()
        setupWeekSwitcher()
        setupPopoverCalendarBtnsRow()
        setupSelectedDaysLabel()
		setupPartitionsNumberPopoverBtn()
        setupCalendarContainer()
        setupWeekDayLabelsStackView()
        setupMonthDaysCollectionView()
        setupWeekDaysCollectionView()
    }
    
    func setupMonthSwitcher() {
        addSubview(monthSwitcher)
        monthSwitcher.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthSwitcher.topAnchor.constraint(equalTo: topAnchor),
            monthSwitcher.centerXAnchor.constraint(equalTo: centerXAnchor),
            monthSwitcher.widthAnchor.constraint(equalToConstant: 190),
            monthSwitcher.heightAnchor.constraint(greaterThanOrEqualToConstant: 55),
        ])
    }
    
    func setupWeekSwitcher() {
        addSubview(weekSwitcher)
        weekSwitcher.translatesAutoresizingMaskIntoConstraints = false
        weekSwitcher.isHidden = true
        
        weekSwitcher.constrainEdgesToCorrespondingEdges(of: monthSwitcher, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    func setupPopoverCalendarBtnsRow() {
        addSubview(calendarPopoverBtnsRow)
        calendarPopoverBtnsRow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarPopoverBtnsRow.topAnchor.constraint(equalTo: monthSwitcher.bottomAnchor, constant: 10),
            calendarPopoverBtnsRow.centerXAnchor.constraint(equalTo: centerXAnchor),
            calendarPopoverBtnsRow.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            calendarPopoverBtnsRow.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setupSelectedDaysLabel() {
        addSubview(selectedDaysLabel)
        
        selectedDaysLabelHeightConstraint = selectedDaysLabel.heightAnchor.constraint(lessThanOrEqualToConstant: allowsRangeSelection ? 30 : 0)
        
        NSLayoutConstraint.activate([
            selectedDaysLabel.topAnchor.constraint(equalTo: calendarPopoverBtnsRow.bottomAnchor, constant: 8),
            selectedDaysLabel.leadingAnchor.constraint(equalTo: calendarPopoverBtnsRow.leadingAnchor),
			selectedDaysLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            selectedDaysLabelHeightConstraint,
        ])
    }
	
	func setupPartitionsNumberPopoverBtn() {
		addSubview(partitionsNumberPopoverBtn)
		
		NSLayoutConstraint.activate([
			partitionsNumberPopoverBtn.centerYAnchor.constraint(equalTo: selectedDaysLabel.centerYAnchor),
			partitionsNumberPopoverBtn.leadingAnchor.constraint(equalTo: selectedDaysLabel.trailingAnchor, constant: 8),
			partitionsNumberPopoverBtn.trailingAnchor.constraint(equalTo: calendarPopoverBtnsRow.trailingAnchor),
			partitionsNumberPopoverBtn.heightAnchor.constraint(equalTo: selectedDaysLabel.heightAnchor)
		])
	}
    
    func setupCalendarContainer() {
        addSubview(calendarContainer)
        calendarContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarContainer.topAnchor.constraint(equalTo: selectedDaysLabel.bottomAnchor, constant: 5),
            calendarContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupWeekDayLabelsStackView() {
        calendarContainer.addSubview(weekDayLabelsStackView)
        weekDayLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = max(LayoutConstants.screenHeight * 0.066, 45)
        weekDayLabelsStackView.layer.cornerRadius = height / 2
        
        NSLayoutConstraint.activate([
            weekDayLabelsStackView.centerXAnchor.constraint(equalTo: calendarContainer.centerXAnchor),
            weekDayLabelsStackView.topAnchor.constraint(equalTo: calendarContainer.topAnchor, constant: 15),
            weekDayLabelsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
            weekDayLabelsStackView.widthAnchor.constraint(equalToConstant: CalendarView.width),
        ])
        
        weekDayLabelsStackView.applyAccentColorGradient(size: CGSize(width: CalendarView.width, height: height), cornerRadius: weekDayLabelsStackView.layer.cornerRadius)
    }
        
    func setupMonthDaysCollectionView() {
        calendarContainer.addSubview(monthDaysCollectionView)
        
        monthDaysCollectionView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            monthDaysCollectionView.centerXAnchor.constraint(equalTo: calendarContainer.centerXAnchor),
            monthDaysCollectionView.topAnchor.constraint(equalTo: weekDayLabelsStackView.bottomAnchor, constant: 8),
            monthDaysCollectionView.bottomAnchor.constraint(equalTo: calendarContainer.bottomAnchor),
            monthDaysCollectionView.widthAnchor.constraint(equalToConstant: CalendarView.width),
        ])
    }
    
    func setupWeekDaysCollectionView() {
        calendarContainer.addSubview(weekDaysCollectionView)
        
        weekDaysCollectionView.isUserInteractionEnabled = true
        
        weekDaysCollectionView.constrainEdgesToCorrespondingEdges(of: monthDaysCollectionView, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    // MARK: Tools
    
    func handleNewMonthSelection(numberOfDaysInMonth: Int, startsAtColumnIndex firstColumnIndex: Int) {
        
        monthDaysCollectionView.minimumSelectableItemRow = firstColumnIndex
        selectedMonthDayItemRow = nil
        monthDaysCollectionView.deselectAllItems(animated: true)
        
        if selectionGestureIsSwitchingToNextMonth {
            monthDaysCollectionView.firstSelectedItemIndexPath = IndexPath(row: monthDaysCollectionView.minimumSelectableItemRow, section: 0)
        }
        
        let dayNumbers = getDayNumbers(numberOfDaysInMonth, firstColumnIndex)
        
        updateWeekDaysNumbers(dayNumbers: dayNumbers)
        updateMonthDaysCellModels(dayNumbers: dayNumbers)
    }
    
    func handleNewWeekSelection(selectedWeekIndex: Int) {
        updateWeekDaysCellModels()
        let selectedWeekDaysNumbers = weekDaysNumbers[selectedWeekIndex]
        weekDayLabelsStackView.updateWeekDayNumbers(with: selectedWeekDaysNumbers)
        (firstWeekDayNumber, lastWeekDayNumber) = getFirstAndLastNumbersInWeekDayNumberLabels(selectedWeekDaysNumbers)
        selectedWeekLabel = "\(firstWeekDayNumber)-\(lastWeekDayNumber)"
        firstWeekDayColumnIndex = selectedWeekDaysNumbers.contains("")
            ? selectedWeekDaysNumbers.lastIndex { $0 == "" }! + 1
            : 0
        lastWeekDayColumnIndex = selectedWeekDaysNumbers.count - 1
    }
    
    func getDayNumbers(_ numberOfDays: Int, _ firstColumnIndex: Int) -> [ClosedRange<Int>.Element] {
        return Array(repeating: 0, count: firstColumnIndex) + (1...numberOfDays)
    }
    
    func updateWeekDaysNumbers(dayNumbers: [Int]) {
        weekDaysNumbers = []
        
        let stringDayNumbers = dayNumbers.map { return $0 == 0 ? "" : String($0)}
        
        for i in stride(from: 0, to: stringDayNumbers.count, by: 7) {
            let weekNumbers = Array(stringDayNumbers[i...min(i + 6, stringDayNumbers.count - 1)])
            weekDaysNumbers.append(weekNumbers)
        }
        
        
    }
        
    func getFirstAndLastNumbersInWeekDayNumberLabels(_ weekDayNumbers: [String]) -> (Int, Int) {
        let firstNumberIndex = weekDayNumbers.firstIndex { $0 != "" }
        let lastNumberIndex = weekDayNumbers.lastIndex { $0 != "" }
        let firstNumber = Int(weekDayNumbers[firstNumberIndex!])!
        let lastNumber = Int(weekDayNumbers[lastNumberIndex!])!
        
        return (firstNumber, lastNumber)
    }
        
    func updateMonthDaysCellModels(dayNumbers: [Int]) {
        monthDayCellModels = dayNumbers.map {
            MonthDayCellModel(dayNumber: $0, includedItems: [])
        }
        
        monthDaysCollectionView.reloadData()
        monthDaysCollectionView.sizeToFit()
    }
    
    func updateWeekDaysCellModels() {
        var index = 0
        let numberOfCells = 24 * 7
        weekDayCellModels = (0...numberOfCells - 1).map { _ in
            let cellIsFirstCellOfRow = index % 7 == 0
            let hourLabel = cellIsFirstCellOfRow ? hourLabels[index / 7] : ""
            index += 1
            
            return WeekDayCellModel(hourLabel: hourLabel, includedItems: [])
        }
        
        weekDaysCollectionView.reloadData()
    }
    
    func updateMonthDaysModelWithDueItems(itemsOfMonthDayRows: [Int: [ItemModel]]) {
        resetMonthDayCellModelsIncludedItems()
        
        for itemRow in itemsOfMonthDayRows.keys {
            guard let items = itemsOfMonthDayRows[itemRow] else { continue }
            monthDayCellModels[itemRow].includedItems = items
        }
        
        monthDaysCollectionView.reloadData()
    }
    
    func updateWeekDaysModelWithDueItems(itemsOfWeekDayRows: [Int: [ItemModel]]) {
        resetWeekDayCellModelsIncludedItems()
        
        for itemRow in itemsOfWeekDayRows.keys {
            guard let items = itemsOfWeekDayRows[itemRow] else { continue }
            weekDayCellModels[itemRow].includedItems = items
        }
        
        weekDaysCollectionView.reloadData()
    }
    
    func resetMonthDayCellModelsIncludedItems() {
        monthDayCellModels = monthDayCellModels.map { monthDayCellModel in
            var updatedMonthDayCellModel = monthDayCellModel
            updatedMonthDayCellModel.includedItems = []
            return updatedMonthDayCellModel
        }
    }
    
    func resetWeekDayCellModelsIncludedItems() {
        weekDayCellModels = weekDayCellModels.map { weekDayCellModel in
            var updatedWeekDayCellModel = weekDayCellModel
            updatedWeekDayCellModel.includedItems = []
            return updatedWeekDayCellModel
        }
    }
    
    func updateSelectedDaysLabel(firstDay: String, lastDay: String) {
        let from = NSLocalizedString("from", comment: "")
        let to = NSLocalizedString("to ", comment: "")
        selectedDaysLabel.attributedText = "\(from) \(firstDay) \(to) \(lastDay)".attributedStringWithColor([from, to], color: .accent, stringSize: 13, coloredSubstringsSize: 13)
    }

    func getWeekDayCellRowBy(weekDayIndex: Int, andHour hour: Int) -> Int {
        assert((0...6) ~= weekDayIndex, "Invalid week day")
        assert((0...23) ~= hour, "Invalid hour")
        return hour * 7 + weekDayIndex + firstWeekDayColumnIndex
    }
}

extension CalendarView: MultipleCellSelectionCollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == monthDaysCollectionView ? monthDayCellModels.count : weekDayCellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == monthDaysCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: monthDayCellReuseIdentifier, for: indexPath) as! MonthDayCell
            
            cell.viewModel = monthDayCellModels[indexPath.row]
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekDayCellReuseIdentifier, for: indexPath) as! WeekDayCell
        
        cell.viewModel = weekDayCellModels[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == monthDaysCollectionView {
            selectedMonthDayItemRow = indexPath.row
            collectionView.deselectAllItemsExceptAt(indexPath, animated: true)
        }
        
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
                cell?.backgroundColor = indexPathsForSelectedItems.count > 1 ? UIColor.accent.withAlphaComponent(0.2) : .clear
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
