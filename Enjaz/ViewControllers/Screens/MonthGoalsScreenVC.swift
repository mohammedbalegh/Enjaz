
import UIKit

class MonthGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {
    
    var category: ItemCategoryModel?
    
    var completedGoals: [ItemModel] = []
    var upcomingGoals: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
                
        guard let category = category else { fatalError("Invalid category") }
        
        let allOriginalCategoryGoals = RealmManager.retrieveItems(withFilter: "type == \(ItemType.goal.id) AND category == \(category.id)").filterOutNonOriginalItems()
        
        completedGoals = allOriginalCategoryGoals.filter { $0.is_completed }
        upcomingGoals = allOriginalCategoryGoals.filter { !$0.is_completed && $0.date > Date().timeIntervalSince1970 }
        
        screenNavigatorCellModels = [
            ScreenNavigatorCellModel(imageSource: "majorGoalsIcon", label: NSLocalizedString("Major goals", comment: ""), subLabel: "\(NSLocalizedString("My goal in life regarding ", comment: ""))\(category.localized_name)")
            ,ScreenNavigatorCellModel(imageSource: "completedGoalsIcon", label: NSLocalizedString("Finished goals", comment: ""), subLabel: "\(completedGoals.count) \(NSLocalizedString("Goal", comment: ""))"),
            ScreenNavigatorCellModel(imageSource: "upcomingGoalsIcon", label: NSLocalizedString("Upcoming goals", comment: ""), subLabel: "\(upcomingGoals.count) \(NSLocalizedString("Goal", comment: ""))"),
            ScreenNavigatorCellModel(imageSource: "rateYourSelfIcon", label: NSLocalizedString("Self Evaluation", comment: ""), subLabel: ""),
            ScreenNavigatorCellModel(imageSource: "addButton", label: NSLocalizedString("Add new goal", comment: ""), subLabel: ""),
        ]
        
        title = "\(NSLocalizedString("\(category.localized_name)", comment: ""))"
        
        tableView.reloadData()
    }
    
    func getUpcomingAndCompletedGoalsScreen(itemModels: [ItemModel], title: String) -> ShowAllItemsScreenVC {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let upcomingAndCompletedGoalsScreenVC = ShowAllItemsScreenVC(collectionViewLayout: layout)
        upcomingAndCompletedGoalsScreenVC.cardModels = itemModels
        upcomingAndCompletedGoalsScreenVC.title = title
        
        return upcomingAndCompletedGoalsScreenVC
    }
    
    func getTargetViewControllerBasedOnIndexPath(_ indexPath: IndexPath) -> UIViewController? {
        switch indexPath.row {
        case 0:
            let vc = MajorGoalsScreenVC()
            vc.categoryId = category!.id
            return vc
        case 1:
            return getUpcomingAndCompletedGoalsScreen(itemModels: completedGoals, title: NSLocalizedString("Completed Goals", comment: ""))
        case 2:
            return getUpcomingAndCompletedGoalsScreen(itemModels: upcomingGoals, title: NSLocalizedString("Upcoming Goals", comment: ""))
        case 3:
            let vc = SelfEvaluationScreenVC()
            vc.categoryId = category!.id
            return vc
        case 4:
            let vc = AddGoalScreenVC()
            vc.category = RealmManager.retrieveItemCategoryById(category!.id)
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
