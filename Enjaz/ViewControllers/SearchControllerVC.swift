import UIKit

class SearchControllerVC: UIViewController {
    
    lazy var itemsTableView: ItemsTableView = {
        let tableView = ItemsTableView()
        tableView.register(ItemsTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .mainScreenBackgroundColor
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        hideKeyboardWhenTouchedAround()
        
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(itemsTableView)
        
        NSLayoutConstraint.activate([
            itemsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            itemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
}
