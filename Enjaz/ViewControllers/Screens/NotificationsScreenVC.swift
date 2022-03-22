import UIKit

class NotificationsScreenVC: UITableViewController {
    
    var items: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Notifications".localized
		
		tableView.backgroundColor = .background
		
		tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "goalsTableCell")
		tableView.allowsSelection = false
		
        updateTable()
    }
	
    func updateTable() {
        let notifications = RealmManager.retrieveItems(withFilter: "date < \(Date().timeIntervalSince1970)")
        items = notifications
        tableView.reloadData()
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsTableCell") as! NotificationTableViewCell
        cell.itemModel = items[indexPath.row]
        return cell
    }
	
}
