
import UIKit

class MainTabBarController: UITabBarController {
    
    lazy var floatingBtn: UIButton = {
        let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		
        button.setBackgroundImage(UIImage(named:"floatingNewAdditionBtn"), for: .normal)
		
		button.layer.shadowColor = UIColor.accentColor.cgColor
		button.layer.shadowOffset = CGSize(width: 0, height: 5)
		button.layer.shadowOpacity = 0.5
		button.layer.shadowRadius = 6
		button.layer.masksToBounds = false
		
		button.addTarget(self, action: #selector(onFloatingBtnTap), for: .touchUpInside)
        
        return button
    }()
	let newAdditionScreenVC = NewAdditionScreenVC()
	
	// Override selectedViewController for User initiated changes
	override var selectedViewController: UIViewController? {
		didSet {
			tabChangedTo(selectedIndex: selectedIndex)
		}
	}
	// Override selectedIndex for Programmatic changes
	override var selectedIndex: Int {
		didSet {
			tabChangedTo(selectedIndex: selectedIndex)
		}
	}
		
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 100
        tabBar.frame.origin.y = view.frame.height - 95
        setupFloatingButton()
    }
	    
    func configureTabBar() {
        setValue(MainTabBar(), forKey: "TabBar")
		
		let homeScreenVC = HomeScreenVC()
		let calendarScreenVC = CalendarScreenVC()
		let goalsScreenVC = GoalsScreenVC()
		let monthlyPlanScreenVC = MonthlyPlanScreenVC()
		
		setTabBarIcon(for: homeScreenVC, withImageName: "homeIcon")
		setTabBarIcon(for: calendarScreenVC, withImageName: "calendarIcon")
		setTabBarIcon(for: goalsScreenVC, withImageName: "graphIcon")
		setTabBarIcon(for: monthlyPlanScreenVC, withImageName: "categoryIcon")
				
		viewControllers = [homeScreenVC, calendarScreenVC, newAdditionScreenVC, goalsScreenVC, monthlyPlanScreenVC]
		
		// Disable the NewAdditionScreen tab bar item, because the screen is accessed through the floating button.
		tabBar.items?[2].isEnabled = false
    }
	    
    func setupFloatingButton() {
        view.addSubview(floatingBtn)
        		
        let size = LayoutConstants.screenWidth * 0.18
		
        NSLayoutConstraint.activate([
            floatingBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            floatingBtn.heightAnchor.constraint(equalToConstant: size),
            floatingBtn.widthAnchor.constraint(equalToConstant: size)
        ])
    }
	
	func setTabBarIcon(for viewController: UIViewController, withImageName imageName: String) {
		viewController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
		viewController.tabBarItem.selectedImage = UIImage(named: "\(imageName)@selected")?.withRenderingMode(.alwaysOriginal)
	}
	
	@objc func onFloatingBtnTap() {
		let newAdditionScreenIsSelected = selectedIndex == 2
		if newAdditionScreenIsSelected {
			newAdditionScreenVC.onSaveBtnTap()
			return
		}
		navigateToNewAdditionScreen()
    }
	
	// MARK: Tools
	
	// Handle new selection
	func tabChangedTo(selectedIndex: Int) {
		let newAdditionScreenIsSelected = selectedIndex == 2
		newAdditionScreenIsSelected
			? setupFloatingBtnAsNewAdditionScreenSaveBtn()
			: setupFloatingBtnAsNewAdditionScreenTabBarItem()
	}
	
	func setupFloatingBtnAsNewAdditionScreenTabBarItem() {
		floatingBtn.setBackgroundImage(UIImage(named:"floatingNewAdditionBtn"), for: .normal)
	}
	
	func setupFloatingBtnAsNewAdditionScreenSaveBtn() {
		floatingBtn.setBackgroundImage(UIImage(named: "floatingSaveButton"), for: .normal)
	}
		
	func navigateToNewAdditionScreen() {
		selectedIndex = 2
	}
}
