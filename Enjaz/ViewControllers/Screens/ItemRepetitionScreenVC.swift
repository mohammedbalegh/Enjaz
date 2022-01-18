import UIKit

class ItemRepetitionScreenVC: ModalVC {

	var itemRepetitionOptions: [Date.DateSeparationType] = [
		.daily,
		.weekly,
		.biweekly,
		.monthly,
		.custom,
	]
	
	let repetitionOptionCellReuseIdentifier = "repetitionOptionCellReuseIdentifier"
	
	var setDateAndTimeScreen: SetDateAndTimeScreenVC?
	
	var delegate: AddItemScreenModalDelegate?
	
	var selectedOption: Date.DateSeparationType?
    
    var selectedDay: Date?
	
	var startDate: Date {
        let startDate = selectedDay ?? Date()
		let startDateComponents = startDate.getDateComponents(forCalendarIdentifier: Calendar.current.identifier)
        
        return Date.generateDateObjectFromComponents(year: startDateComponents.year!, month: startDateComponents.month!, day: startDateComponents.day!, hour: startDateComponents.hour!, calendarIdentifier: Calendar.current.identifier)
	}
	
	var endDate: Date {
		let endYear = Date.getCurrentYear(forCalendarIdentifier: Calendar.current.identifier) + 15
		return Date.generateDateObjectFromComponents(year: endYear, month: 12, day: 31, hour: 12, calendarIdentifier: Calendar.current.identifier)
	}
	
	lazy var repetitionOptionsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .insetGrouped)
		
		tableView.backgroundColor = .clear
		
		tableView.register(ItemRepetitionOptionsTableViewCell.self, forCellReuseIdentifier: repetitionOptionCellReuseIdentifier)
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		return tableView
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        view.backgroundColor = .systemGroupedBackground | .modalScreenBackground
		title = "Repetition".localized
		navigationController?.navigationBar.prefersLargeTitles = true
		
		setupTableView()
		selectLastSelectedOption()
    }
	
	func setupTableView() {
		view.addSubview(repetitionOptionsTableView)
		
		NSLayoutConstraint.activate([
			repetitionOptionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			repetitionOptionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			repetitionOptionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			repetitionOptionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
		
	// MARK: Tools
	
	func selectLastSelectedOption() {
		guard let selectedOption = selectedOption, let selectedOptionRow = itemRepetitionOptions.firstIndex(of: selectedOption) else { return }
		
		repetitionOptionsTableView.selectRow(at: IndexPath(row: selectedOptionRow, section: 0), animated: false, scrollPosition: .none)
		
	}
	
	func navigateToSetDateAndTimeScreen() {
		guard let setDateAndTimeScreen = setDateAndTimeScreen else { return }
		navigationController?.pushViewController(setDateAndTimeScreen, animated: true)
	}
	
	func handleOptionSelection(repetitionOption: Date.DateSeparationType) {
		let selectedDates = Date.generateConsecutiveDates(from: startDate, to: endDate, separatedBy: repetitionOption)
		
		let selectedDatesUnixTimeStamps = selectedDates.map { $0.timeIntervalSince1970 }
		
		delegate?.handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: [selectedDatesUnixTimeStamps], readableDate: repetitionOption.rawValue.localized, repetitionOption: repetitionOption)
		dismiss(animated: true)
	}
	
}


extension ItemRepetitionScreenVC: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? itemRepetitionOptions.count - 1 : 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = repetitionOptionsTableView.dequeueReusableCell(withIdentifier: repetitionOptionCellReuseIdentifier) as! ItemRepetitionOptionsTableViewCell
		
		cell.option = indexPath.section == 0 ? itemRepetitionOptions[indexPath.row] : itemRepetitionOptions.last
				
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1 {
			navigateToSetDateAndTimeScreen()
			return
		}
		
		handleOptionSelection(repetitionOption: itemRepetitionOptions[indexPath.row])
	}
	
}
