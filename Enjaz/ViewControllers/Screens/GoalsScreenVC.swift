
import UIKit

class GoalsScreenVC: MenuBarNavigationVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        menuItems = [NSLocalizedString("My Goals", comment: ""), NSLocalizedString("Goals Bank", comment: "")]
        viewControllers = [MyGoalsScreenVC(), GoalsBankScreenVC()]
    }
    
}


