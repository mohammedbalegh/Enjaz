import UIKit
import SPAlert

struct ItemTools {
	
	private static let alertPopup = AlertPopup()
	
	private static func instantiateAchievement(from item: ItemModel) {
		let achievement = ItemModel()
		achievement.name = item.name
		achievement.date = item.date
		achievement.item_description = item.item_description
		achievement.category_id = item.category_id
		achievement.type_id = ItemType.achievement.id
		achievement.image_id = item.image_id == ItemType.goal.imageId ? ItemType.achievement.imageId : item.image_id
		
		RealmManager.saveItem(achievement)
	}
	
	static func showCongratsPopup(for item: ItemModel) {
		let itemType = ItemType.getTypeById(id: item.type_id)
		let popupImage = UIImage(named: "congratsIcon")
		let popupTitle = NSLocalizedString("Congrats", comment: "")
		var popupMessage = String(format: NSLocalizedString("%@ completed successfully", comment: ""), itemType.localizedName)
		
		var actions: [AlertPopupAction] = []
		
		if itemType == .goal {
			popupMessage = popupMessage + "\n" + NSLocalizedString("Would you like to add it as an achievement?", comment: "")
			
			let noAction = AlertPopupAction(title: NSLocalizedString("No", comment: ""), style: .normal) {
				alertPopup.dismiss(animated: true)
			}
			
			let yesAction = AlertPopupAction(title: NSLocalizedString("Yes", comment: ""), style: .normal) {
				instantiateAchievement(from: item)
				
				let successMessage = String(format: NSLocalizedString("%@ was added successfully", comment: ""), ItemType.achievement.localizedName)
				SPAlert.present(title: successMessage, preset: .done)
				
				alertPopup.dismiss(animated: true)
			}
			
			actions = [noAction, yesAction]
		}
		
		alertPopup.present(withImage: popupImage, title: popupTitle, message: popupMessage, actions: actions)
	}
	
}
