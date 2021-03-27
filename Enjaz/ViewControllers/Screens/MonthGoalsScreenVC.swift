
import UIKit

class MonthGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let completedGoals = RealmManager.retrieveCompletedGoals()
        let upcomingGoals = RealmManager.retrieveUpcomingGoals()
        
        view.backgroundColor = .mainScreenBackgroundColor
        screenNavigatorCellModels = [
            ScreenNavigatorCellModel(imageSource: "completedGoalsIcon", label: "أهداف منتهية", subLabel: "\(completedGoals.count) هدف"),
            ScreenNavigatorCellModel(imageSource: "upcomingGoalsIcon", label: "أهداف قادمة", subLabel: "\(upcomingGoals.count)  هدف"),
            ScreenNavigatorCellModel(imageSource: "healthSideIcon", label: "تقييم النفس", subLabel: "لا يوجد تقييم"),
        ]
        
        tableViewTitle = "أهدافك"
        
        let upcomingAndCompletedGoalsScreenVC = UpcomingAndCompletedGoalsScreenVC()
        
        upcomingAndCompletedGoalsScreenVC.completedGoals = completedGoals
        upcomingAndCompletedGoalsScreenVC.upcomingGoals = upcomingGoals
        
        targetTableViewController = upcomingAndCompletedGoalsScreenVC
        targetViewController = SelfEvaluationScreenVC()
        
        tableView.reloadData()
    }

}
