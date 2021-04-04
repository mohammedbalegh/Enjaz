import UIKit
import SideMenu

class MainTabBarController: UITabBarController {
	    
    lazy var islamicDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.text = DateAndTimeTools.getReadableDate(from: Date(), withFormat: "dd MMMM", calendarIdentifier: .islamicCivil)
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var georgianDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.text = DateAndTimeTools.getReadableDate(from: Date(), withFormat: "d MMMM yyyy", calendarIdentifier: .gregorian)
        label.font = label.font.withSize(14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateVerticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [islamicDateLabel, georgianDateLabel])
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
        
        button.addTarget(self, action: #selector(handleMenuBtnTap), for: .touchUpInside)
        
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
		
		button.addTarget(self, action: #selector(handleFloatingBtnTap), for: .touchUpInside)
		
		return button
	}()
    
    lazy var sideMenu: UIViewController? = {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: view)
        let sideMenu = layoutDirection == .leftToRight ? SideMenuManager.default.leftMenuNavigationController : SideMenuManager.default.rightMenuNavigationController
        
        return sideMenu
    }()

    var screenTitles: [String]?
    let additionTypeScreenVC = AdditionTypeScreenVC()
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
		
		viewControllers = [homeScreenVC, calendarScreenVC, additionTypeScreenVC, monthlyPlanScreenVC, goalsScreenVC]
        screenTitles = [NSLocalizedString("Home", comment: ""),
                        NSLocalizedString("Calendar", comment: ""),
                        NSLocalizedString("Choose Addition Type", comment: ""),
                        NSLocalizedString("Monthly Plan", comment: ""),
                        NSLocalizedString("Goals", comment: "")]
        
		// Disable the additionTypeScreen tab bar item, because the screen is accessed through the floating button.
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
    
	@objc func handleFloatingBtnTap() {
        let additionStackIsSelected = selectedIndex == 2
        
		if additionStackIsSelected {
            handleAdditionTypeScreenSelectionBtnTap()
			return
		}
        
		navigateToAdditionTypeScreen()
	}
    
    func handleAdditionTypeScreenSelectionBtnTap() {
        if additionTypeScreenVC.selectedTypeId == -1 {
            AlertBottomSheetView.shared.presentAsError(withMessage: NSLocalizedString("No type has been selected", comment: ""))
            return
        }
        
        let addItemScreenVC = AddItemScreenVC()
        
        addItemScreenVC.itemType = additionTypeScreenVC.selectedTypeId
        
        navigationController?.pushViewController(addItemScreenVC, animated: true)
        additionTypeScreenVC.resetCardSelection()
    }
	
    @objc func handleMenuBtnTap() {
        guard let sideMenu = sideMenu else { return }
        present(sideMenu, animated: true, completion: nil)
    }
    
	// MARK: Tools
        
	// Handle new selection
	func tabChangedTo(selectedIndex: Int) {
		let additionTypeScreenIsSelected = selectedIndex == 2
		
        additionTypeScreenIsSelected
			? setupFloatingBtnAsSelectBtn()
			: setupFloatingBtnAsTabBarItem()
		
        navigationItem.titleView = selectedIndex == 0 ? dateVerticalStack : navBarTitleLabel

        navBarTitleLabel.text = screenTitles?[selectedIndex]
	}
    
	func setupFloatingBtnAsTabBarItem() {
		floatingBtn.setBackgroundImage(UIImage(named:"floatingNewAdditionBtn"), for: .normal)
	}
	
	func setupFloatingBtnAsSelectBtn() {
		floatingBtn.setBackgroundImage(UIImage(named: "floatingSaveButton"), for: .normal)
	}
	
	func navigateToAdditionTypeScreen() {
		selectedIndex = 2
	}
}
