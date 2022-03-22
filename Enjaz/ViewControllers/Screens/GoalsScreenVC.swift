
import UIKit

class GoalsScreenVC: MenuBarNavigationVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        menuItems = ["My Goals".localized, "Goals Bank".localized]
        viewControllers = [MyGoalsScreenVC(), GoalsBankScreenVC()]
    }
    
}


