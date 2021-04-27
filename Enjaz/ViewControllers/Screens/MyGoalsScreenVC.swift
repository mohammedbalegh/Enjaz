import UIKit

class MyGoalsScreenVC: ScreenNavigatorTableVC {
	    
    var itemCategories: [ItemCategoryModel] = []
    var toBeDeletedCategoryIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		headerCellModels = [ScreenNavigatorTableViewHeaderCellModel(title: NSLocalizedString("Choose goal category", comment: ""), addBtnTitle: NSLocalizedString("Add new category", comment: ""))]
		let headerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCustomHeaderCell
		headerCell?.addBtn.addTarget(self, action: #selector(handleAddBtnTap), for: .touchUpInside)
		
        updateScreen()
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
        
		tableView.deleteRows(at: [toBeDeletedCategoryIndexPath], with: .automatic)
		self.toBeDeletedCategoryIndexPath = nil
    }
    
    @objc func handleAddBtnTap() {
		parent?.navigationController?.pushViewController(AddCategoryScreenVC(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthGoalsScreenVC = MonthGoalsScreenVC()
        monthGoalsScreenVC.category = itemCategories[indexPath.row]
		parent?.navigationController?.pushViewController(monthGoalsScreenVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presentConfirmDeletionActionSheet()
        toBeDeletedCategoryIndexPath = indexPath
    }
	    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		guard indexPath.section == 1 else { return .none }
		
        let itemCategory = itemCategories[indexPath.row]
		return itemCategory.is_default ? .none : .delete
    }
	
	override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		guard indexPath.section == 1 else { return nil }
		
		let itemCategory = itemCategories[indexPath.row]
		
		guard !itemCategory.is_default else { return nil }
		
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
			let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), image: UIImage(systemName: "trash"), attributes: .destructive) { action in
				self.presentConfirmDeletionActionSheet()
				self.toBeDeletedCategoryIndexPath = indexPath
			}
			return UIMenu(title: "", children: [deleteAction])
		})
	}
}
