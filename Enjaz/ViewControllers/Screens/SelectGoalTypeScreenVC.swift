import UIKit

class SelectGoalTypeScreenVC: ScreenNavigatorWithDynamicDataTableVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        tableViewTitle = "اختر مجال الهدف"
        targetViewController = AddGoalScreenVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
    
    func updateScreen() {
        let itemCategories  = RealmManager.retrieveItemCategories()
        screenNavigatorCellModels = itemCategories.map { itemCategory in
            return ScreenNavigatorCellModel(imageSource: itemCategory.image_source, label: itemCategory.localized_name, subLabel: itemCategory.localized_description)
        }
        
        tableView.reloadData()
    }
    
}
