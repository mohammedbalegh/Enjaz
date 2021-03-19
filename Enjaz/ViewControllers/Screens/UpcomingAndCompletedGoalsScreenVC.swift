
import UIKit

class UpcomingAndCompletedGoalsScreenVC: ScreenNavigatorWithDynamicDataTableVC {

    var completedGoals: [ItemModel]?
    var upcomingGoals: [ItemModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainScreenBackgroundColor
        
        if id == 0 {
            
            
            title = "اهداف منتهية"
        } else {
            
            title = "اهداف قادمة"
        }
        
        targetViewController = AddGoalScreenVC()
        tableView.reloadData()
    }

}
