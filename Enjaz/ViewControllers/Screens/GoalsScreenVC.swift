
import UIKit

class GoalsScreenVC: MenuBarNavigationVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuItems = ["الاهداف الكبري", "إضافة هدف", "أهداف الشهر", "بنك الاهداف",]
        controllerViews = [MajorGoalsScreenVC(),SelectGoalTypeScreenVC(),MonthGoalsScreenVC(),GoalsBankScreenVC()]
    }
    
}


