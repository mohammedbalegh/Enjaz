import UIKit

class NotificationsScreenVC: UIViewController {
    
    var items: [ItemModel] = []
    
    lazy var notificationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .background
        
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "goalsTableCell")
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        setupNotificationsTableView()
        title = NSLocalizedString("Notifications", comment: "")
    }
    
    func setupNotificationsTableView() {
        view.addSubview(notificationsTableView)
        
        NSLayoutConstraint.activate([
            notificationsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            notificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            notificationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func updateTable() {
        let notifications = RealmManager.retrieveItems(withFilter: "date < \(Date().timeIntervalSince1970)")
        items = notifications
        notificationsTableView.reloadData()
    }
}

extension NotificationsScreenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsTableCell") as! NotificationTableViewCell
        cell.itemModel = items[indexPath.row]
        return cell
    }
    
    
}
