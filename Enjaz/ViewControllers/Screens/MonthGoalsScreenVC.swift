
import UIKit

class MonthGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let completedGoals = RealmManager.retrieveCompletedGoals()
        let upcomingGoals = RealmManager.retrieveUpcomingGoals()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        screenNavigatorCellModels = [
            ScreenNavigatorCellModel(image: UIImage(named: "completedGoalsIcon"), label: "أهداف منتهية", subLabel: "\(completedGoals.count) هدف"),
            ScreenNavigatorCellModel(image: UIImage(named: "upcomingGoalsIcon"), label: "أهداف قادمة", subLabel: "\(upcomingGoals.count)  هدف"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "تقيم النفس", subLabel: "لا يوجد تقيم"),
        ]
                
        tableViewTitle = "أهدافك"
        
        let upcomingAndCompletedGoalsScreenVC = UpcomingAndCompletedGoalsScreenVC()
        
        upcomingAndCompletedGoalsScreenVC.completedGoals = completedGoals
        upcomingAndCompletedGoalsScreenVC.upcomingGoals = upcomingGoals
        
        targetTableViewController = upcomingAndCompletedGoalsScreenVC
        
        tableView.reloadData()
    }

}
