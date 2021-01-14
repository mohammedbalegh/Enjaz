
import UIKit

class GoalsBankScreenVC: UIViewController {
    
    var goalSuggestions: [String] = []
    
    var goalsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .rootTabBarScreensBackgroundColor
        tableView.tableFooterView = UIView()
        tableView.register(GoalsTableCell.self, forCellReuseIdentifier: "goalsTableCell")
        return tableView
    }()
    
    let suggestionsLabel: UILabel = {
        let label = UILabel()
        label.text = "أقتراحات لبعض الأهداف"
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .accentColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        setupSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateScreen()
    }
    
    func updateScreen() {
        NetworkingManager.retrieveGoalSuggestions() { goalSuggestions in
            self.goalSuggestions = goalSuggestions
            self.goalsTableView.reloadData()
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
        cell.goalLabel.text = "\(goalSuggestions[indexPath.row])"
        return cell
    }
}
