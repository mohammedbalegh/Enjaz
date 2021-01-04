
import UIKit

class UpcomingAndCompletedGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {

    var completedGoals: [ItemModel]?
    var upcomingGoals: [ItemModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        if id == 0 {
            
            
            title = "اهداف منتهية"
        } else {
            
            title = "اهداف غير منتهية"
        }
        
        
        targetViewController = AddGoalScreenVC()
        tableView.reloadData()
    }

}
