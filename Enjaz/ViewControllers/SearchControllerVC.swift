import UIKit

class SearchControllerVC: UIViewController {
    
    lazy var itemsTableView: ItemsTableView = {
        let tableView = ItemsTableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
        tableView.backgroundColor = .background
		tableView.keyboardDismissMode = .interactive
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
		tableView.register(ItemsTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
		
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(itemsTableView)
        
        NSLayoutConstraint.activate([
            itemsTableView.topAnchor.constraint(equalTo: view.topAnchor),
			itemsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            itemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
}
