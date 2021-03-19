import UIKit

class PopoverTableVC: UITableViewController {

	let reuseIdentifier = "cell"
	
	var dataSourceArray: [String] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	var optionSelectionHandler: ((_: Int) -> Void)?
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .white
		tableView.backgroundColor = .white
		tableView.register(PopoverTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scrollToTop()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSourceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PopoverTableViewCell
		
		cell.label.text = dataSourceArray[indexPath.row]
				
        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return LayoutConstants.calendarViewPopoverCellHeight
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		optionSelectionHandler?(indexPath.row)
		dismiss(animated: true)
	}
    
    func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

}
