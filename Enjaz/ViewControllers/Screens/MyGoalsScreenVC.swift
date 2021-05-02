import UIKit

class MyGoalsScreenVC: ScreenNavigatorTableVC {
	    
    var itemCategories: [ItemCategoryModel] = []
	
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
    
	func presentConfirmDeletionActionSheet(forCategoryAt indexPath: IndexPath, completion: ((_ completed: Bool) -> Void)? = nil) {
		let title = NSLocalizedString("Are you sure you want to delete category?", comment: "")
		let message = NSLocalizedString("All related goals, demahs, achievements and tasks will be deleted as well. This action cannot be undone.", comment: "")
		
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		
		let deleteAction = UIAlertAction(title: NSLocalizedString("Delete Category", comment: ""), style: .destructive) {_ in
			self.deleteCategory(at: indexPath, completion: completion)
		}
		
		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) {_ in
			completion?(false)
		}
		
		actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(actionSheet, animated: true)
    }
    
	func deleteCategory(at indexPath: IndexPath, completion: ((_ completed: Bool) -> Void)? = nil) {
        let itemCategory = itemCategories[indexPath.row]
        
        RealmManager.deleteItemCategory(itemCategory)
        
        itemCategories.remove(at: indexPath.row)
        screenNavigatorCellModels.remove(at: indexPath.row)
        
		tableView.deleteRows(at: [indexPath], with: .automatic)
		completion?(true)
    }
    
    @objc func handleAddBtnTap() {
		parent?.navigationController?.pushViewController(AddCategoryScreenVC(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthGoalsScreenVC = MonthGoalsScreenVC()
        monthGoalsScreenVC.category = itemCategories[indexPath.row]
		parent?.navigationController?.pushViewController(monthGoalsScreenVC, animated: true)
    }
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard indexPath.section == 1 else { return nil }
		
		let itemCategory = itemCategories[indexPath.row]
		guard !itemCategory.is_default else { return nil }
		
		let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion  in
			self.presentConfirmDeletionActionSheet(forCategoryAt: indexPath, completion: completion)
		}
		deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
		
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}
	
	override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		guard indexPath.section == 1 else { return nil }
		
		let itemCategory = itemCategories[indexPath.row]
		guard !itemCategory.is_default else { return nil }
		
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
			let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), image: UIImage(systemName: "trash"), attributes: .destructive) { action in
				self.presentConfirmDeletionActionSheet(forCategoryAt: indexPath)
			}
			return UIMenu(title: "", children: [deleteAction])
		})
	}
}
