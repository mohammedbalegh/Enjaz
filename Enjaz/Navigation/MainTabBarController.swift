
import UIKit

class MainTabBarController: UITabBarController {
    
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
        viewControllers = [GoalsScreenVC(), MonthlyPlanScreenVC(), UIViewController(), CalendarScreenVC(), HomeScreenVC()]
        
        tabBar.items![0].image = UIImage(named: "HomeIcon")
        tabBar.items![1].image = UIImage(named: "CalendarIcon")
        tabBar.items![3].image = UIImage(named: "GraphIcon")
		tabBar.items![4].image = UIImage(named: "CategoryIcon")
    }
    
    func setupFloatingButton() {
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(floatingButtonClicked), for: .touchUpInside)
        let size = LayoutConstants.screenWidth * 0.25
        NSLayoutConstraint.activate([
            floatingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            floatingButton.heightAnchor.constraint(equalToConstant: size),
            floatingButton.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
    @objc func floatingButtonClicked() {
        print("button clicked")
    }
    
}
