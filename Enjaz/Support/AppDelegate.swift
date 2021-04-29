import UIKit
import ReSwift
import Network

let store = Store(reducer: appReducer, state: AppState(), middleware: [])

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureNavigationBarAppearance()
		configureTabBarAppearance()
        monitorInternetConnection()
        AppDataInitializer.initializeItemCategories()
		AppDataInitializer.initializeItemImages()
        AppDataInitializer.initializePersonalAspects()
        
        return true
    }
        
    func configureNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = .accent
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.accent]
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
	
	func configureTabBarAppearance() {
		UITabBar.appearance().backgroundImage = UIImage()
		UITabBar.appearance().shadowImage = UIImage()
		UITabBar.appearance().clipsToBounds = true
	}
    
    func monitorInternetConnection() {
        let monitor = NWPathMonitor()
                
        monitor.pathUpdateHandler = { path in
            let isConnectedToInternet = path.status == .satisfied
            store.dispatch(SetIsConnectedToInternetAction(isConnectedToInternet: isConnectedToInternet))
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

}

