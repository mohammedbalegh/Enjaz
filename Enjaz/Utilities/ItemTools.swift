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
		let popupTitle = "Congrats".localized
		var popupMessage = String(format: "%@ completed successfully".localized, itemType.localizedName)
		
		var actions: [AlertPopupAction] = []
		
		if itemType == .goal {
			popupMessage = popupMessage + "\n" + "Would you like to add it as an achievement?".localized
			
			let noAction = AlertPopupAction(title: "No".localized, style: .normal) {
				alertPopup.dismiss(animated: true)
			}
			
			let yesAction = AlertPopupAction(title: "Yes".localized, style: .normal) {
				instantiateAchievement(from: item)
				
				let successMessage = String(format: "%@ was added successfully".localized, ItemType.achievement.localizedName)
				SPAlert.present(title: successMessage, preset: .done)
				
				alertPopup.dismiss(animated: true)
			}
			
			actions = [noAction, yesAction]
		}
		
		alertPopup.present(withImage: popupImage, title: popupTitle, message: popupMessage, actions: actions)
	}
	
}
