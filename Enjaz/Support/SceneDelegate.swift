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
        
        let sideMenuVC = SideMenuVC()
        let menuNavigationController = SideMenuNavigationController(rootViewController: sideMenuVC)
        let layoutDirectionIsRTL = LayoutTools.getCurrentLayoutDirection(for: rootViewController.view) == .rightToLeft
        
        if layoutDirectionIsRTL {
            SideMenuManager.default.rightMenuNavigationController = menuNavigationController
        } else {
            SideMenuManager.default.leftMenuNavigationController = menuNavigationController
        }
        
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: rootViewController.view, forMenu: layoutDirectionIsRTL ? .right : .left)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootViewController
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
}

