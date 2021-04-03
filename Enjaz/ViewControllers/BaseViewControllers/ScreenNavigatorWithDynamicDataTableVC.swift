import UIKit

class ScreenNavigatorWithDynamicDataTableVC: UITableViewController {
    
    let navigationBtnIdentifier = "navigationBtnIdentifier"
    var tableViewTitle: String?
    
    var addBtnTitle: String?
    var addBtnTapHandler: Selector?
    
    var screenNavigatorCellModels: [ScreenNavigatorCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight, right: 0)
        
        tableView.register(ScreenNavigatorTableViewCell.self, forCellReuseIdentifier: navigationBtnIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenNavigatorCellModels.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewCustomHeader = TableViewCustomHeader(reuseIdentifier: "header")
        tableViewCustomHeader.label.text = tableViewTitle
        return tableViewCustomHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: navigationBtnIdentifier, for: indexPath) as! ScreenNavigatorTableViewCell
        
        cell.viewModel = screenNavigatorCellModels[indexPath.row]
        
        return cell
    }
    
}
