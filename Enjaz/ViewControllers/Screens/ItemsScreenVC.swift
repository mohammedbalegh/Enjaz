import UIKit
import SPAlert

class ItemsScreenVC: UITableViewController {    
	var items: [ItemModel] = [] {
		didSet {
			noItemsLabel.isHidden = !items.isEmpty
		}
	}
	
    let itemCardPopup = ItemCardPopup()
	let alertPopup = AlertPopup()
	
	let noItemsLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.font = .systemFont(ofSize: 18)
		label.textColor = .systemGray2
		label.textAlignment = .center
		
		return label
	}()
	
	var presentedItemIndexPath: IndexPath!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = 70
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = .background
		tableView.keyboardDismissMode = .interactive
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.tabBarHeight, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
		tableView.register(ItemsTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
		
		view.addSubview(noItemsLabel)
		noItemsLabel.center(relativeTo: view)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let title = title {
			noItemsLabel.text = NSLocalizedString("No item", comment: "") + " \(title.lowercased())"
		}
	}
		

	func updateScreen() {
		handleItemPinUpdate(at: presentedItemIndexPath)
	}
	
//	@abstract
	func handleItemCompletionUpdate(at indexPath: IndexPath) {}
	
	func handleItemPinUpdate(at indexPath: IndexPath) {
		let item = getItem(at: indexPath)
		items = items.sorted { $0.date < $1.date }.sorted { $0.is_pinned && !$1.is_pinned }
		
		let newItemRowIndex = items.firstIndex(of: item)!
		let newItemIndexPath = IndexPath(row: newItemRowIndex, section: indexPath.section)
		
		let cell = tableView.cellForRow(at: indexPath) as? ItemsTableViewCell
		cell?.isPinned = item.is_pinned
		
		guard newItemIndexPath.row != indexPath.row else { return }
		
		tableView.moveRow(at: indexPath, to: newItemIndexPath)
	}
	
	// MARK: Tools
	
	func presentConfirmDeletionActionSheet(forItemAt indexPath: IndexPath, completion: ((_ completed: Bool) -> Void)? = nil) {
		let item = getItem(at: indexPath)
		let (itemDeletionWarningTitle, deletionWarningMessage) = getDeletionWarningTitleAndMessage(forItem: item)
		
		let actionSheet = UIAlertController(title: itemDeletionWarningTitle, message: deletionWarningMessage, preferredStyle: .actionSheet)
		
		let deleteActionTitle = String(format: NSLocalizedString("Delete %@", comment: ""), ItemType.getTypeById(id: item.type_id).localizedName)  
		
		let deleteAction = UIAlertAction(title: deleteActionTitle, style: .destructive) { _ in
			self.deleteItem(at: indexPath, completion: completion)
		}
		
		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
			completion?(false)
		}
		
		actionSheet.addAction(deleteAction)
		actionSheet.addAction(cancelAction)
		
		actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
		present(actionSheet, animated: true)
	}
	
	func getDeletionWarningTitleAndMessage(forItem item: ItemModel) -> (String, String) {
		let itemType = ItemType.getTypeById(id: item.type_id)
		let itemTypeName = itemType.localizedName.lowercased()
		let pluralItemTypeName = NSLocalizedString(itemType.name.pluralizeInEnglish(), comment: "").removeDefinitionArticle().lowercased()
		
		let itemDeletionWarningTitle = String(format: NSLocalizedString("Are you sure you want to delete %@?", comment: ""), itemTypeName)
		
		let singleItemDeletionWarningMessage = NSLocalizedString("This action cannot be undone.", comment: "")
		
		let repeatingItemDeletionWarningMessage = String(format: NSLocalizedString("All subsequent %@ will be deleted as well.", comment: ""), pluralItemTypeName) + " \(singleItemDeletionWarningMessage)"
		
		let deletionWarningMessage = item.is_repeated
			? repeatingItemDeletionWarningMessage
			: singleItemDeletionWarningMessage
		
		return (itemDeletionWarningTitle, deletionWarningMessage)
	}
			
	func deleteItem(at indexPath: IndexPath, completion: ((_ completed: Bool) -> Void)? = nil) {
		let toBeDeletedItem = getItem(at: indexPath)
		
		removeRow(at: indexPath)
		RealmManager.deleteItem(toBeDeletedItem)
		
		completion?(true)
	}
	
	func completeItem(at indexPath: IndexPath, completion: ((_ completed: Bool) -> Void)? = nil) {
		let item = getItem(at: indexPath)
		
		guard !item.is_completed else {
			let itemType = ItemType.getTypeById(id: item.type_id)
			let alertMessage = String(format: NSLocalizedString("%@ is already completed", comment: ""), itemType.localizedName)

			SPAlert.present(message: alertMessage, haptic: .none)
			completion?(true)
			return
		}
		
		RealmManager.completeItem(item, isCompleted: true)
		completion?(true)
		ItemTools.showCongratsPopup(for: item)
		handleItemCompletionUpdate(at: indexPath)
	}
	
	func pinItem(at indexPath: IndexPath, completion: ((_ completed: Bool) -> Void)? = nil) {
		let item = getItem(at: indexPath)
		let newPinState = !item.is_pinned
		
		RealmManager.pinItem(item, isPinned: newPinState)
		
		handleItemPinUpdate(at: indexPath)
		completion?(true)
	}
	
	func removeRow(at indexPath: IndexPath) {
		items.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	func getItem(at indexPath: IndexPath) -> ItemModel { items[indexPath.row] }
	    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemsTableViewCell
        cell.itemModel = items[indexPath.row]
		cell.selectionStyle = .none
        return cell
    }
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Dismiss keyboard
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		keyWindow?.endEditing(true)
		
        let item = getItem(at: indexPath)
        itemCardPopup.itemModels = [item]
		itemCardPopup.itemsUpdateHandler = updateScreen
		presentedItemIndexPath = indexPath
        itemCardPopup.present(animated: true)
    }
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion  in
			self.presentConfirmDeletionActionSheet(forItemAt: indexPath, completion: completion)
		}
		deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
		
		let completeAction = UIContextualAction(style: .normal, title: nil) { _, _, completion  in
			self.completeItem(at: indexPath, completion: completion)
		}
		completeAction.backgroundColor = .systemBlue
		completeAction.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
		
		return UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
	}
	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let item = getItem(at: indexPath)
		
		let pinAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion  in
			self.pinItem(at: indexPath, completion: completion)
		}
		
		pinAction.backgroundColor = .systemYellow
		let pinActionImageName = item.is_pinned ? "pin.slash.fill" : "pin.fill"
		pinAction.image = UIImage(systemName: pinActionImageName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
		
		return UISwipeActionsConfiguration(actions: [pinAction])
	}
	
	override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let item = getItem(at: indexPath)
		
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
			let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), image: UIImage(systemName: "trash"), attributes: .destructive) { action in
				self.presentConfirmDeletionActionSheet(forItemAt: indexPath)
			}
			
			let completeAction = UIAction(title: NSLocalizedString("Mark as Completed", comment: ""), image: UIImage(systemName: "checkmark.circle")) { action in
				self.completeItem(at: indexPath)
			}
			
			let pinActionTitle = item.is_pinned ? "Unpin" : "Pin"
			let pinActionImageName = item.is_pinned ? "pin.slash" : "pin"
			let pinAction = UIAction(title: NSLocalizedString(pinActionTitle, comment: ""), image: UIImage(systemName: pinActionImageName)) { action in
				self.pinItem(at: indexPath)
			}
			
			return UIMenu(title: "", children: [completeAction, pinAction, deleteAction])
		})
	}
}
