
import UIKit

class MonthGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {
    
    var category: ItemCategoryModel?
    
    var completedGoals: [ItemModel] = []
    var upcomingGoals: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let category = category else { fatalError("Invalid category") }
            
        completedGoals = RealmManager.retrieveCompletedGoals(ofCategory: category)
        upcomingGoals = RealmManager.retrieveUpcomingGoals(ofCategory: category)
                
        view.backgroundColor = .mainScreenBackgroundColor
        screenNavigatorCellModels = [
            ScreenNavigatorCellModel(imageSource: "completedGoalsIcon", label: "أهداف منتهية", subLabel: "\(completedGoals.count) هدف"),
            ScreenNavigatorCellModel(imageSource: "upcomingGoalsIcon", label: "أهداف قادمة", subLabel: "\(upcomingGoals.count)  هدف"),
            ScreenNavigatorCellModel(imageSource: "healthSideIcon", label: "تقييم النفس", subLabel: "لا يوجد تقييم"),
        ]
        
        tableViewTitle = "أهدافك"
        
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
            return getUpcomingAndCompletedGoalsScreen(itemModels: completedGoals, title: NSLocalizedString("Completed Goals", comment: ""))
        case 1:
            return getUpcomingAndCompletedGoalsScreen(itemModels: upcomingGoals, title: NSLocalizedString("Upcoming Goals", comment: ""))
        case 2:
            return SelfEvaluationScreenVC()
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
