
import UIKit

class MonthGoalsScreenVC: ScreenNavigatorTableVC {
    
    var category: ItemCategoryModel?
    
    var completedGoals: [ItemModel] = []
    var upcomingGoals: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
		
	override func viewWillAppear(_ animated: Bool) {
		guard let category = category else { fatalError("Invalid category") }
		
		title = "\("\(category.localized_name)".localized)"
		updateScreen()
	}
		
	func updateScreen() {
		guard let category = category else { return }
		
		let allOriginalCategoryGoals = RealmManager.retrieveItems(withFilter: "type_id == \(ItemType.goal.id) AND category_id == \(category.id)").filterOutNonOriginalItems()
		
		completedGoals = allOriginalCategoryGoals.filter { $0.is_completed }
		upcomingGoals = allOriginalCategoryGoals.filter { !$0.is_completed && $0.date > Date().timeIntervalSince1970 }
		
		screenNavigatorCellModels = [
			ScreenNavigatorCellModel(imageSource: "majorGoalsIcon", label: "Major goals".localized, subLabel: "\("My goal in life regarding ".localized)\(category.localized_name.lowercased())")
			,ScreenNavigatorCellModel(imageSource: "completedGoalsIcon", label: "Completed goals".localized, subLabel: "\(completedGoals.count) \("Goal".localized)"),
			ScreenNavigatorCellModel(imageSource: "upcomingGoalsIcon", label: "Upcoming goals".localized, subLabel: "\(upcomingGoals.count) \("Goal".localized)"),
			ScreenNavigatorCellModel(imageSource: "rateYourSelfIcon", label: "Self Evaluation".localized, subLabel: ""),
			ScreenNavigatorCellModel(imageSource: "addButton", label: "Add new goal".localized, subLabel: ""),
		]
		
		tableView.reloadData()
	}
	
	func getCompletedGoalsScreen(itemModels: [ItemModel], title: String) -> ItemsScreenVC {
		return getUpcomingAndCompletedGoalsScreen(itemModels: itemModels, title: title, isUpcoming: false)
	}
	
	func getUpcomingGoalsScreen(itemModels: [ItemModel], title: String) -> ItemsScreenVC {
		return getUpcomingAndCompletedGoalsScreen(itemModels: itemModels, title: title, isUpcoming: true)
	}
	
	func getUpcomingAndCompletedGoalsScreen(itemModels: [ItemModel], title: String, isUpcoming: Bool) -> ItemsScreenVC {
		let upcomingAndCompletedGoalsScreenVC = isUpcoming ? UpcomingGoalsScreenVC() : ItemsScreenVC()
		upcomingAndCompletedGoalsScreenVC.items = itemModels
		upcomingAndCompletedGoalsScreenVC.title = title
		
		return upcomingAndCompletedGoalsScreenVC
	}
	    
    func getTargetViewControllerBasedOnIndexPath(_ indexPath: IndexPath) -> UIViewController? {
		guard let category = category else { return nil }
		
        switch indexPath.row {
        case 0:
            let vc = MajorGoalsScreenVC()
            vc.categoryId = category.id
            return vc
        case 1:
            return getCompletedGoalsScreen(itemModels: completedGoals, title: "Completed Goals".localized)
        case 2:
			return getUpcomingGoalsScreen(itemModels: upcomingGoals, title: "Upcoming Goals".localized)
        case 3:
            let vc = SelfEvaluationScreenVC()
            vc.categoryId = category.id
            return vc
        case 4:
            let vc = AddGoalScreenVC()
            vc.category = RealmManager.retrieveItemCategoryById(category.id)
            return vc
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let targetViewController = getTargetViewControllerBasedOnIndexPath(indexPath) {
            navigationController?.pushViewController(targetViewController, animated: true)
        }
    }    
}
