import UIKit
import ReSwift
import Network
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

let store = Store(reducer: appReducer, state: AppState(), middleware: [])

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureNavigationBarAppearance()
        monitorInternetConnection()
        AppCenter.start(withAppSecret: "5ad785cd-60c5-4762-863c-bc3cc4d2811e", services:[
          Analytics.self,
          Crashes.self
        ])
        
        return true
    }
    
    func configureNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = .accentColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.accentColor]
        UINavigationBar.appearance().backItem?.backButtonTitle = ""
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
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

