
import UIKit
import SideMenu

class MainTabBarController: UITabBarController {
	    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = DateAndTimeTools.getDate()
        label.font = label.font.withSize(14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var islamicDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x011942)
        label.text = DateAndTimeTools.getDateInIslamic()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateVerticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [islamicDateLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(named:"menuIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(onMenuBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    let notificationsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(named:"bellIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "إضافة جديدة"
        label.textAlignment = .center
        label.textColor = .accentColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    var screenTitles: [String]?
	let newAdditionScreenVC = NewAdditionScreenVC()
    let tabBarHeight = LayoutConstants.tabBarHeight
	
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
                
        navigationItem.titleView = dateVerticalStack
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationsButton)
        
        configureTabBar()
        setupFloatingBtn()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        // Remove the bottom border of the navigationBar
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(named: "navBarBackground"), for: .default)
        navigationBar?.shadowImage = UIImage()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tabBar.frame.size.height = tabBarHeight
		tabBar.frame.origin.y = view.frame.height - tabBarHeight
	}
    
	func configureTabBar() {
		setValue(MainTabBar(), forKey: "TabBar")
		let homeScreenVC = HomeScreenVC()
		let calendarScreenVC = CalendarScreenVC()
		let monthlyPlanScreenVC = MonthlyPlanScreenVC()
		let goalsScreenVC = GoalsScreenVC()
		
		setTabBarIcon(for: homeScreenVC, withImageName: "homeIcon")
		setTabBarIcon(for: calendarScreenVC, withImageName: "calendarIcon")
		setTabBarIcon(for: monthlyPlanScreenVC, withImageName: "graphIcon")
        setTabBarIcon(for: goalsScreenVC, withImageName: "categoryIcon")
		
		viewControllers = [homeScreenVC, calendarScreenVC, newAdditionScreenVC, monthlyPlanScreenVC, goalsScreenVC]
        screenTitles = ["الرئيسية", "التقويم", "إضافة جديدة", "الخطة الشهرية", "الأهداف"]
		
		// Disable the NewAdditionScreen tab bar item, because the screen is accessed through the floating button.
		tabBar.items?[2].isEnabled = false
	}
		
	func setupFloatingBtn() {
		view.addSubview(floatingBtn)
		
		let size = LayoutConstants.screenWidth * 0.18
		
		let bottomOffset = tabBarHeight - tabBarHeight * 0.3
		
		NSLayoutConstraint.activate([
			floatingBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			floatingBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomOffset),
			floatingBtn.heightAnchor.constraint(equalToConstant: size),
			floatingBtn.widthAnchor.constraint(equalToConstant: size)
		])
	}
	
	func setTabBarIcon(for viewController: UIViewController, withImageName imageName: String) {
		viewController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
		viewController.tabBarItem.selectedImage = UIImage(named: "\(imageName)@selected")?.withRenderingMode(.alwaysOriginal)
	}
	
    // MARK: Event Handlers
    
	@objc func onFloatingBtnTap() {
		let newAdditionScreenIsSelected = selectedIndex == 2
		if newAdditionScreenIsSelected {
			newAdditionScreenVC.onSaveBtnTap()
			return
		}
		navigateToNewAdditionScreen()
	}
	
    @objc func onMenuBtnTap() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuVC())
        present(menu, animated: true, completion: nil)
    }
    
	// MARK: Tools
    
	// Handle new selection
	func tabChangedTo(selectedIndex: Int) {
		let newAdditionScreenIsSelected = selectedIndex == 2
		
		newAdditionScreenIsSelected
			? setupFloatingBtnAsNewAdditionScreenSaveBtn()
			: setupFloatingBtnAsNewAdditionScreenTabBarItem()
		
        navigationItem.titleView = selectedIndex == 0 ? dateVerticalStack : navBarTitleLabel

        navBarTitleLabel.text = screenTitles?[selectedIndex]
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
