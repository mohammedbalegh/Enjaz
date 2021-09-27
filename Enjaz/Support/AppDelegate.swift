import UIKit
import ReSwift
import Network
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

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
        
        AppCenter.start(withAppSecret: "5ad785cd-60c5-4762-863c-bc3cc4d2811e", services:[
          Analytics.self,
          Crashes.self
        ])
        
        return true
    }
        
    func configureNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = .accent
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.accent]
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

