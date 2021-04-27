
import UIKit

class MonthlyPlanScreenVC: MenuBarNavigationVC {
	
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
		showSmallTabBar = true
		
        menuItems = [
            NSLocalizedString("Tasks", comment: ""),
            NSLocalizedString("Demahs", comment: ""),
            NSLocalizedString("Achievements", comment: ""),
        ]
		        
        viewControllers = [MonthTasksScreenVC(), MonthDemahsScreenVC(), AchievementsScreenVC()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.accent], for: .normal)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
	}
    
}
