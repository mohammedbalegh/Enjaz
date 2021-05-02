import UIKit

class UpcomingGoalsScreenVC: ItemsScreenVC {

	override func updateScreen() {
		super.updateScreen()
		
		let item = getItem(at: presentedItemIndexPath)
		
		if item.is_completed {
			removeRow(at: presentedItemIndexPath)
		}
	}
	
	override func handleItemCompletionUpdate(at indexPath: IndexPath) {
		removeRow(at: indexPath)
	}

}
