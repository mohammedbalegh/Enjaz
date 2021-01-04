import UIKit

class ScreenNavigatorWithDynamicDataTableVC: UITableViewController {
    
    let customHeaderIdentifier = "customHeaderIdentifier"
    let navigationBtnIdentifier = "navigationBtnIdentifier"
    var tableViewTitle: String?
    
    var screenNavigatorCellModels: [ScreenNavigatorCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var id: Int?
    
    var targetViewController: SelectableScreenVC?
    var targetTableViewController: ScreenNavigatorWithDynamicDataTableVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight, right: 0)
        
        tableView.register(TableViewCustomHeader.self, forCellReuseIdentifier: customHeaderIdentifier)
        tableView.register(ScreenNavigatorTableViewCell.self, forCellReuseIdentifier: navigationBtnIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : screenNavigatorCellModels.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 50 : 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customHeaderIdentifier, for: indexPath) as! TableViewCustomHeader
            
            cell.label.text = tableViewTitle
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: navigationBtnIdentifier, for: indexPath) as! ScreenNavigatorTableViewCell
        
        cell.viewModel = screenNavigatorCellModels[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        print("enterd \(indexPath.row)")
        
        if targetTableViewController is SelectGoalTypeScreenVC {
            print("yes sur")
        }
        
        if indexPath.row < 2, let targetTableViewController = targetTableViewController {
            print("enterd if")
            targetTableViewController.id = indexPath.row
            navigationController?.pushViewController(targetTableViewController, animated: true)
            return
        }
        
        
        if let targetViewController = targetViewController {
            targetViewController.id = indexPath.row
            navigationController?.pushViewController(targetViewController, animated: true)
        }
    }
}
