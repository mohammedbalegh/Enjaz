import UIKit

class ItemsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
	var items: [ItemModel] = [] {
		didSet {
			reloadData()
		}
	}
    
    let itemCardPopup = ItemCardPopup()
    
    init() {
        super.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        rowHeight = 70
		tableFooterView = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemsTableViewCell
        cell.itemModel =  items[indexPath.row]
		cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if let topController = keyWindow?.rootViewController {
            topController.dismissKeyboard()
        }
        
        itemCardPopup.itemModels = [items[indexPath.row]]
        itemCardPopup.present(animated: true)
    }
}
