import UIKit

class MyGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {
    
    var itemCategories: [ItemCategoryModel] = []
    var toBeDeletedCategoryIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        tableViewTitle = NSLocalizedString("Choose goal category", comment: "")
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
        itemCategories = RealmManager.retrieveItemCategories()
        screenNavigatorCellModels = itemCategories.map { itemCategory in
            return ScreenNavigatorCellModel(imageSource: itemCategory.image_source, label: itemCategory.localized_name, subLabel: itemCategory.localized_description)
        }
        
        tableView.reloadData()
    }
    
    func presentConfirmDeletionActionSheet() {
        let actionSheet = UIAlertController(title: NSLocalizedString("Are you sure you want to delete category?", comment: ""), message: NSLocalizedString("All related goals, demahs, achievements and tasks will be deleted as well. This action cannot be undone.", comment: ""), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Delete Category", comment: ""), style: .destructive, handler: deleteCategory))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(actionSheet, animated: true)
    }
    
    func deleteCategory(_ alertAction: UIAlertAction) {
        guard let toBeDeletedCategoryIndexPath = toBeDeletedCategoryIndexPath else { return }

        let toBeDeletedItemCategoryId = itemCategories[toBeDeletedCategoryIndexPath.row].id
        
        RealmManager.deleteItemCategory(categoryId: toBeDeletedItemCategoryId)
        
        itemCategories.remove(at: toBeDeletedCategoryIndexPath.row)
        screenNavigatorCellModels.remove(at: toBeDeletedCategoryIndexPath.row)
        
        tableView.deleteRows(at: [toBeDeletedCategoryIndexPath], with: .fade)
    }
    
    @objc func handleAddBtnTap() {
        navigationController?.pushViewController(AddCategoryScreenVC(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthGoalsScreenVC = MonthGoalsScreenVC()
        monthGoalsScreenVC.category = itemCategories[indexPath.row]
        navigationController?.pushViewController(monthGoalsScreenVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        presentConfirmDeletionActionSheet()
        toBeDeletedCategoryIndexPath = indexPath
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let itemCategory = itemCategories[indexPath.row]
        if itemCategory.is_default {
            return .none
        }
        
        return .delete
    }
}
