import UIKit

class ScreenNavigatorTableVC: UITableViewController {
    
	let headerReuseIdentifier = "headerReuseIdentifier"
    let navigationBtnIdentifier = "navigationBtnIdentifier"
	
	var headerCellModels: [ScreenNavigatorTableViewHeaderCellModel] = []
    
	var screenNavigatorCellModels: [ScreenNavigatorCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        
        tableView.register(TableViewCustomHeaderCell.self, forCellReuseIdentifier: headerReuseIdentifier)
		tableView.register(ScreenNavigatorTableViewCell.self, forCellReuseIdentifier: navigationBtnIdentifier)
    }
        
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : screenNavigatorCellModels.count
    }
	
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier, for: indexPath) as! TableViewCustomHeaderCell
			cell.viewModel = headerCellModels.first
			return cell
		}
		
        let cell = tableView.dequeueReusableCell(withIdentifier: navigationBtnIdentifier, for: indexPath) as! ScreenNavigatorTableViewCell
        cell.viewModel = screenNavigatorCellModels[indexPath.row]
        return cell
    }
	
}
