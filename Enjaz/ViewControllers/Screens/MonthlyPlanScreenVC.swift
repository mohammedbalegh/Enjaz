
import UIKit

class MonthlyPlanScreenVC: MenuBarNavigationVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        
        menuItems = [
            NSLocalizedString("Tasks", comment: ""),
            NSLocalizedString("Demahs", comment: ""),
            NSLocalizedString("Achievements", comment: ""),
        ]
        
        controllerViews = [MonthTasksScreenVC(), MonthDemahsScreenVC(), AchievementsScreenVC()]
    }
    
}
