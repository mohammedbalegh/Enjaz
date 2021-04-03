import UIKit

class MyGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        tableViewTitle = NSLocalizedString("Choose goal category", comment: "")
        targetViewController = AddGoalScreenVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tableViewHeader = tableView.headerView(forSection: 0) as? TableViewCustomHeader {
            tableViewHeader.addBtn.isHidden = false
            tableViewHeader.addBtn.addTarget(self, action: #selector(handleAddBtnTap), for: .touchUpInside)
            tableViewHeader.addBtn.setTitle(NSLocalizedString("Add new category", comment: ""), for: .normal)
        }
    }
    
    func updateScreen() {
        let itemCategories  = RealmManager.retrieveItemCategories()
        screenNavigatorCellModels = itemCategories.map { itemCategory in
            return ScreenNavigatorCellModel(imageSource: itemCategory.image_source, label: itemCategory.localized_name, subLabel: itemCategory.localized_description)
        }
        
        tableView.reloadData()
    }
    
    @objc func handleAddBtnTap() {
        print("HIIIIIII")
    }
    
}
