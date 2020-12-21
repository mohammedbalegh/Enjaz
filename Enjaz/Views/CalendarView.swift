import UIKit

class CalendarView: UIView {
	
	var monthDayCellModels: [MonthDayCellModel] = []
	
	let popoverBtnsHSVHorizontalPadding: CGFloat = LayoutConstants.screenWidth * 0.04
	
	let popoverBtnsHSVHeight: CGFloat = 40
	
	let popoverBtnsHSVTopOffset: CGFloat = 20
	
	lazy var popoverCalendarBtnsHSV = PopoverCalendarBtnsStackView(frame: CGRect(x: popoverBtnsHSVHorizontalPadding, y: popoverBtnsHSVTopOffset, width: LayoutConstants.calendarViewWidth - (popoverBtnsHSVHorizontalPadding * 2), height: popoverBtnsHSVHeight))
	
	lazy var weekDayLabelsHSV: UIStackView = {
		let labels = createWeekDayLabels()
		
		let stackView = UIStackView(arrangedSubviews: labels)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.alignment = .center
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	lazy var monthDaysCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.sectionHeadersPinToVisibleBounds = true
		let layoutItemWidth = (LayoutConstants.calendarViewWidth / 7) - 1
		layout.itemSize = CGSize(width: layoutItemWidth, height: layoutItemWidth * 0.8)
		
		// Collection View
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.clipsToBounds = true
		collectionView.backgroundColor = .white
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(MonthDayCell.self, forCellWithReuseIdentifier: monthDayCellReuseIdentifier)
				
		return collectionView
	}()
	
	// MARK: State
	
	var selectedMonthDayCellIndex: Int?
	
	let monthDayCellReuseIdentifier = "monthDayCell"
		
	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
				
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: View Setups
	
	func setup() {
		setupSubviews()
	}
	
	func setupSubviews() {
		addSubview(popoverCalendarBtnsHSV)
		setupWeekDayLabelsHSV()
		setupMonthDaysCollectionView()
	}	
	
	func setupWeekDayLabelsHSV() {
		addSubview(weekDayLabelsHSV)
		
		let height: CGFloat = 60
		weekDayLabelsHSV.layer.cornerRadius = height / 2
		
		NSLayoutConstraint.activate([
			weekDayLabelsHSV.topAnchor.constraint(equalTo: topAnchor, constant: popoverBtnsHSVHeight + popoverBtnsHSVTopOffset + 20),
			weekDayLabelsHSV.leadingAnchor.constraint(equalTo: leadingAnchor),
			weekDayLabelsHSV.trailingAnchor.constraint(equalTo: trailingAnchor),
			weekDayLabelsHSV.heightAnchor.constraint(equalToConstant: height),
		])
		
		weekDayLabelsHSV.applyAccentColorGradient(size: CGSize(width: LayoutConstants.calendarViewWidth, height: height), cornerRadius: weekDayLabelsHSV.layer.cornerRadius)
	}
	
	func setupMonthDaysCollectionView() {
		addSubview(monthDaysCollectionView)
		
		monthDaysCollectionView.isUserInteractionEnabled = true
		
		NSLayoutConstraint.activate([
			monthDaysCollectionView.topAnchor.constraint(equalTo: weekDayLabelsHSV.bottomAnchor, constant: 5),
			monthDaysCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			monthDaysCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            monthDaysCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
	
	func updateMonthDaysModel(numberOfDaysInMonth: Int, startsAtColumnNumber: Int) {
		monthDayCellModels = generateMonthDaysCellModels(numberOfDaysInMonth: numberOfDaysInMonth, startsAtColumnNumber: startsAtColumnNumber)
		monthDaysCollectionView.reloadData()
	}
	
	func generateMonthDaysCellModels(numberOfDaysInMonth numberOfDays: Int, startsAtColumnNumber firstColumnNumber: Int) -> [MonthDayCellModel] {
		var models: [MonthDayCellModel] = []
		
		for i in 0...((numberOfDays - 1) + firstColumnNumber) {
			let dayNumber = i < firstColumnNumber ? 0 : (i - firstColumnNumber) + 1
			
			models.append(MonthDayCellModel(dayNumber: dayNumber, isSelected: false, includesItem: false))
		}
		
		return models
	}	
}


extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
		
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return monthDayCellModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: monthDayCellReuseIdentifier, for: indexPath) as! MonthDayCell
		
		cell.viewModel = monthDayCellModels[indexPath.row]
				
		return cell
	}
	
	func setCellSelection(at index: Int, selected: Bool) {
        guard index < monthDayCellModels.count else { return }
        
		var selectedCellModel = monthDayCellModels[index]
		selectedCellModel.isSelected = selected
		
		monthDayCellModels[index] = selectedCellModel
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		guard indexPath.row != (selectedMonthDayCellIndex ?? -1) else { return }

		setCellSelection(at: indexPath.row, selected: true)

		if let selectedMonthDayCellIndex = selectedMonthDayCellIndex {
			setCellSelection(at: selectedMonthDayCellIndex, selected: false)
		}

		selectedMonthDayCellIndex = indexPath.row

		collectionView.reloadData()
	}
		
}