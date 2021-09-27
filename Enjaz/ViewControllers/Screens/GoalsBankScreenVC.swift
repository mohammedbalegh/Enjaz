
import UIKit

class GoalsBankScreenVC: UITableViewController {
    
    var goalSuggestions: [GoalSuggestionsModel] = []
	
    lazy var headerLabel: UILabel = {
		let label = UILabel(frame: CGRect(x: 8, y: 0, width: view.frame.width - 8, height: 50))
        label.text = NSLocalizedString("Some goals suggestions", comment: "")
        label.font = label.font.withSize(16)
		label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .accent
        return label
    }()
	
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
		
		configureTableView()
		
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		
        goalSuggestions = UserDefaultsManager.goalsBank ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
	
    func updateScreen() {
		if !refreshControl!.isRefreshing && goalSuggestions.isEmpty {
			refreshControl!.beginRefreshing()
		}
		
        NetworkingManager.retrieveGoalSuggestions() { goals, error in
			DispatchQueue.main.async {
				self.refreshControl!.endRefreshing()
				
				guard let goals = goals else {
					print(error!)
					return
				}
				
				self.goalSuggestions = goals
				UserDefaultsManager.goalsBank = goals
				self.tableView.reloadData()
            }
        }
    }
	
	@objc func handleRefresh() {
		updateScreen()
	}
	
	func configureTableView() {
		tableView.backgroundColor = .clear
		tableView.tableFooterView = UIView()
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
		tableView.register(GoalsTableCell.self, forCellReuseIdentifier: "goalsTableCell")
		tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerReuseIdentifier")
	}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalSuggestions.count
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsTableCell") as! GoalsTableCell
        cell.cellCount.text = "\(indexPath.row + 1)"
        cell.goalLabel.text = "\(goalSuggestions[indexPath.row].text)"
        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UITableViewHeaderFooterView(reuseIdentifier: "headerReuseIdentifier")
		view.contentView.addSubview(headerLabel)
		view.contentView.backgroundColor = .background
		return view
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		headerLabel.frame.height
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let goalSuggestion = goalSuggestions[indexPath.row].text
		
		let addItemScreenVC = AddItemScreenVC()
		addItemScreenVC.itemType = ItemType.goal.id
		addItemScreenVC.additionNameTextField.input?.inputText = goalSuggestion
		
		navigationController?.present(UINavigationController(rootViewController: addItemScreenVC), animated: true)
	}
	
}
