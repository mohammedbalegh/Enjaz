import UIKit

class DailyViewCell: UICollectionViewCell {
    let hourCellReuseIIdentifier = "hourCell"
    let hourLabels = DateAndTimeTools.twelveHourFormatHourLabels
    
    var dailyViewHourModels: [DailyViewHourModel] = []
    
    var viewModel: DailyViewDayModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            dailyViewHourModels = generateDailyViewHourModels(includedItemsInDay: viewModel.includedItems)
            tableView.reloadData()
			scrollToFirstIncludedItem()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(HourTableViewCell.self, forCellReuseIdentifier: hourCellReuseIIdentifier)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
	
	var itemSelectionHandler: ((_ selectedItem: [ItemModel]) -> Void)?
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 28
        clipsToBounds = true
        setupTableView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        contentView.addSubview(tableView)
        tableView.constrainEdgesToCorrespondingEdges(of: contentView, top: 0, leading: 7, bottom: 0, trailing: -7)
    }
    
    func generateDailyViewHourModels(includedItemsInDay: [ItemModel]) -> [DailyViewHourModel] {
        var updatedHourModels: [DailyViewHourModel] = []
        
        for hour in hourLabels {
            updatedHourModels.append(DailyViewHourModel(hour: hour, includedItems: [], isShowingAllIncludedItems: false))
        }
        
        for item in includedItemsInDay {
            let itemDateComponents = DateAndTimeTools.getComponentsOfUnixTimeStampDate(timeIntervalSince1970: item.date, forCalendarIdentifier: Calendar.current.identifier)
            updatedHourModels[itemDateComponents.hour ?? 0].includedItems.append(item)
        }
        
        return updatedHourModels
    }
        
    func showAllIncludedItems(at rowIndex: Int) {
        dailyViewHourModels[rowIndex].isShowingAllIncludedItems = true
		
        let otherIncludedItems = dailyViewHourModels[rowIndex].includedItems.dropFirst()
        var newRowsIndexPaths: [IndexPath] = []
        var index = 1
        for otherIncludedItem in otherIncludedItems {
            dailyViewHourModels.insert(DailyViewHourModel(hour: "", includedItems: [otherIncludedItem], isShowingAllIncludedItems: false), at: rowIndex + index)
            newRowsIndexPaths.append(IndexPath(row: rowIndex + index, section: 0))
            index += 1
        }
		
        tableView.insertRows(at: newRowsIndexPaths, with: .automatic)
    }
    
    func hideOtherIncludedItems(at rowIndex: Int) {
        dailyViewHourModels[rowIndex].isShowingAllIncludedItems = false
        
        let otherIncludedItems = dailyViewHourModels[rowIndex].includedItems.dropFirst()
        var toBeDeletedRowsIndexPaths: [IndexPath] = []
        
        for index in 1...otherIncludedItems.count {
            dailyViewHourModels.remove(at: rowIndex + 1)
            toBeDeletedRowsIndexPaths.append(IndexPath(row: rowIndex + index, section: 0))
        }
        
        tableView.deleteRows(at: toBeDeletedRowsIndexPaths, with: .automatic)
    }
	
	func scrollToFirstIncludedItem() {
		let indexPathOfFirstIncludedItem = getIndexPathOfFirstIncludedItem()
		tableView.scrollToRow(at: indexPathOfFirstIncludedItem, at: .middle, animated: false)
	}
	
	func getIndexPathOfFirstIncludedItem() -> IndexPath {
		for (index, dailyViewHourModel) in dailyViewHourModels.enumerated() {
			if dailyViewHourModel.includesItems {
				return IndexPath(row: index, section: 0)
			}
		}
		
		return IndexPath(row: 0, section: 0)
	}
    
}

extension DailyViewCell: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyViewHourModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: hourCellReuseIIdentifier) as! HourTableViewCell
        cell.viewModel = dailyViewHourModels[indexPath.row]
        cell.row = indexPath.row
        cell.showAllBtnHandler = showAllIncludedItems
        cell.showLessBtnHandler = hideOtherIncludedItems
        return cell
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		let isShowingAllIncludedItems = dailyViewHourModels[indexPath.row].isShowingAllIncludedItems
		let items = dailyViewHourModels[indexPath.row].includedItems
		guard let firstItem = items.first else { return }
		
		itemSelectionHandler?(isShowingAllIncludedItems ? [firstItem] : items)
	}
	
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return UIView() }
        
        let header = DailyViewTableViewCustomHeader()
        
        header.dayNumberLabel.text = String(format: "%02d", viewModel.dayNumber)
        header.weekDayNameLabel.text = viewModel.weekDayName
        let numberOfItems = viewModel.includedItems.count
        header.numberOfItemsLabel.text = String(numberOfItems) + " " + NSLocalizedString("Task", comment: "")
        
        if Locale.current.languageCode == "en" {
            header.numberOfItemsLabel.text! += numberOfItems > 1 ? "s" : ""
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 39
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
	
}
