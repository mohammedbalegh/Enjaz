import UIKit
import SideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let loggedIn = UserDefaultsManager.isLoggedIn
        
//        let loggedIn = false // For testing.
        
        let rootViewController = UINavigationController(rootViewController: loggedIn ? MainTabBarController() : StartScreenVC())
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootViewController
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        window?.makeKeyAndVisible()
    }
}

