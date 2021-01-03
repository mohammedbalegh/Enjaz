import UIKit

class AddGoalScreenVC: NewAdditionScreenVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        title = "إضافة هدف"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if #available(iOS 14.0, *) {
            navigationController?.navigationBar.backItem?.backButtonDisplayMode = .minimal
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
