
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
    
    let floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(named:"floatingImage"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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
        viewControllers = [HomeScreenVC(), MonthlyPlanScreenVC(), UIViewController(), CalendarScreenVC(), GoalsScreenVC()]
        
        tabBar.items![0].image = UIImage(named: "HomeIcon")
        tabBar.items![1].image = UIImage(named: "CalendarIcon")
        tabBar.items![3].image = UIImage(named: "GraphIcon")
		tabBar.items![4].image = UIImage(named: "CategoryIcon")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items![0] {
            showTapBar(type: .date, title: "")
        } else if item == tabBar.items![1] {
            showTapBar(type: .title, title: "التقويم")
        } else if item == tabBar.items![3] {
            showTapBar(type: .title, title: "الخطة الشهرية")
        } else if item == tabBar.items![4] {
            showTapBar(type: .title, title: "الأهداف")
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
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(floatingButtonClicked), for: .touchUpInside)
        let size = LayoutConstants.screenWidth * 0.25
        NSLayoutConstraint.activate([
            floatingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: LayoutConstants.screenHeight * -0.05),
            floatingButton.heightAnchor.constraint(equalToConstant: size),
            floatingButton.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
    @objc func floatingButtonClicked() {
        print("button clicked")
    }
    
}
