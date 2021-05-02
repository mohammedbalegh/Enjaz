
import UIKit

class GoalsBankScreenVC: UIViewController {
    
    var goalSuggestions: [GoalSuggestionsModel] = []
    
    var refreshControl = UIRefreshControl()
    
    var goalsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .background
        tableView.tableFooterView = UIView()
		
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
		
        tableView.register(GoalsTableCell.self, forCellReuseIdentifier: "goalsTableCell")
        tableView.allowsSelection = false
        return tableView
    }()
    
    let suggestionsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("", comment: "Some goals suggestions")
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .accent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        goalsTableView.insertSubview(refreshControl, at: 0)
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        goalSuggestions = UserDefaultsManager.goalsBank ?? []
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateScreen()
    }
    
    @objc func onRefresh() {
        updateScreen()
    }
    
    func updateScreen() {
		if !refreshControl.isRefreshing {
			refreshControl.beginRefreshing()
		}
		
        NetworkingManager.retrieveGoalSuggestions() { goals, error in
			DispatchQueue.main.async {
				self.refreshControl.endRefreshing()
					
				guard let goals = goals else {
					print(error!)
					return
				}
				
				self.goalSuggestions = goals
				UserDefaultsManager.goalsBank = goals
                self.goalsTableView.reloadData()
            }
        }
    }
    
    func setupSubviews() {
        setupSuggestionsLabel()
        setupGoalsTableView()
    }
    
    func setupSuggestionsLabel() {
        view.addSubview(suggestionsLabel)
        
        NSLayoutConstraint.activate([
            suggestionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.027),
            suggestionsLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            suggestionsLabel.heightAnchor.constraint(equalToConstant: 20),
            suggestionsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
        ])
    }
    
    func setupGoalsTableView() {
        view.addSubview(goalsTableView)
        
        NSLayoutConstraint.activate([
            goalsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goalsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goalsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            goalsTableView.topAnchor.constraint(equalTo: suggestionsLabel.bottomAnchor, constant: 15),
        ])
    }
    

}

extension GoalsBankScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsTableCell") as! GoalsTableCell
        cell.cellCount.text = "\(indexPath.row + 1)"
        cell.goalLabel.text = "\(goalSuggestions[indexPath.row].text)"
        return cell
    }
}
