
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
		
		title = "\(NSLocalizedString("\(category.localized_name)", comment: ""))"
		updateScreen()
	}
		
	func updateScreen() {
		guard let category = category else { return }
		
		let allOriginalCategoryGoals = RealmManager.retrieveItems(withFilter: "type == \(ItemType.goal.id) AND category == \(category.id)").filterOutNonOriginalItems()
		
		completedGoals = allOriginalCategoryGoals.filter { $0.is_completed }
		upcomingGoals = allOriginalCategoryGoals.filter { !$0.is_completed && $0.date > Date().timeIntervalSince1970 }
		
		screenNavigatorCellModels = [
			ScreenNavigatorCellModel(imageSource: "majorGoalsIcon", label: NSLocalizedString("Major goals", comment: ""), subLabel: "\(NSLocalizedString("My goal in life regarding ", comment: ""))\(category.localized_name.lowercased())")
			,ScreenNavigatorCellModel(imageSource: "completedGoalsIcon", label: NSLocalizedString("Completed goals", comment: ""), subLabel: "\(completedGoals.count) \(NSLocalizedString("Goal", comment: ""))"),
			ScreenNavigatorCellModel(imageSource: "upcomingGoalsIcon", label: NSLocalizedString("Upcoming goals", comment: ""), subLabel: "\(upcomingGoals.count) \(NSLocalizedString("Goal", comment: ""))"),
			ScreenNavigatorCellModel(imageSource: "rateYourSelfIcon", label: NSLocalizedString("Self Evaluation", comment: ""), subLabel: ""),
			ScreenNavigatorCellModel(imageSource: "addButton", label: NSLocalizedString("Add new goal", comment: ""), subLabel: ""),
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
            return getCompletedGoalsScreen(itemModels: completedGoals, title: NSLocalizedString("Completed Goals", comment: ""))
        case 2:
			return getUpcomingGoalsScreen(itemModels: upcomingGoals, title: NSLocalizedString("Upcoming Goals", comment: ""))
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
