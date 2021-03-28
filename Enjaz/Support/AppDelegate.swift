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
        AppDataInitializer.initializeItemCategories()
        
        if RealmManager.retrieveAspectsCount() == 0 {
            
            addMainAspects(title: "Who am i", brief: "Write what you know about your self", image: "whoAmIImage", badge: "whoAmIBadge", description: "Translate what you know about your self from dreams and ambitions into goals, to achieve as much as possible year")
            
            addMainAspects(title: "My mission in life", brief: "Write your life mission", image: "lifeMissionImage", badge: "lifeMissionBadge", description: "Your life mission is you answer to the \"why\" question , what are the values that you stand behind, you life mission should be comprehensive, inspiring, and rememberable")
            
            addMainAspects(title: "My vision in life", brief: "Write your life vision", image: "visionImage", badge: "visionBadge", description: "life vision answers the \"why\" and \"where\" , where will your feature be ?, what it will be like, what will you do in 5 or 10 years ")

        }
        
        AppCenter.start(withAppSecret: "5ad785cd-60c5-4762-863c-bc3cc4d2811e", services:[
          Analytics.self,
          Crashes.self
        ])
        
        return true
    }
    
    func addMainAspects(title: String, brief: String, image: String, badge: String, description: String) {
        let aspect = PersonalAspectsModel()
        
        aspect.title = NSLocalizedString(title, comment: "")
        aspect.briefOrDate = NSLocalizedString(brief, comment: "")
        aspect.image = (UIImage(named: image)?.toBase64())!
        aspect.badge = (UIImage(named: badge)?.toBase64())!
        aspect.aspect_description = NSLocalizedString(description, comment: "")
        
        RealmManager.saveAspect(aspect)
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

