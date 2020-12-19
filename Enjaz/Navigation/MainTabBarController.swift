
import UIKit

class MainTabBarController: UITabBarController {
    
    enum TapBarTypes {
        case title
        case date
    }
    
    let tabBarHeight = LayoutConstants.screenHeight * 0.10
    
    let topBar: NavBarTabView = {
        let bar = NavBarTabView()
        bar.title.isHidden = true
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
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
        view.tintColor = .accentColor
        setupSubviews()
    }
    
    func setupSubviews() {
        configureTabBar()
        setupFloatingButton()
        setupTopBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight
    }
    
    func setupTopBar() {
        view.addSubview(topBar)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (LayoutConstants.screenHeight  * 0.03)),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.08)
        ])
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
    }
    
    func showTapBar(type: TapBarTypes, title: String?) {
        if type == TapBarTypes.title {
            topBar.title.isHidden = false
            topBar.dateLabel.isHidden = true
            topBar.islamicDateLabel.isHidden = true
            topBar.title.text = title
        } else if type == TapBarTypes.date {
            topBar.title.isHidden = true
            topBar.dateLabel.isHidden = false
            topBar.islamicDateLabel.isHidden = false
        }
        
    }
    func setupFloatingButton() {
        view.addSubview(floatingBtn)
        		
        let size = LayoutConstants.screenWidth * 0.18
		
        NSLayoutConstraint.activate([
            floatingBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: LayoutConstants.screenHeight * -0.05),
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
    
    if selectedIndex == 0 {
        showTapBar(type: .date, title: "")
    } else if selectedIndex == 1 {
        showTapBar(type: .title, title: "التقويم")
    } else if selectedIndex == 2 {
        showTapBar(type: .title, title: "إضافة جديدة")
    } else if selectedIndex == 3 {
        showTapBar(type: .title, title: "الخطة الشهرية")
    } else if selectedIndex == 4 {
        showTapBar(type: .title, title: "الأهداف")
    }
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
