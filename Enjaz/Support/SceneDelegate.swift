import UIKit
import SideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {        
        guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let rootTabBarController = RootTabBarController()
		
        let rootViewController = UINavigationController(rootViewController: rootTabBarController)
        
        let sideMenuVC = SideMenuVC()
        let menuNavigationController = SideMenuNavigationController(rootViewController: sideMenuVC)
        let layoutDirectionIsRTL = LayoutTools.getCurrentLayoutDirection(for: rootTabBarController.view) == .rightToLeft
        
        if layoutDirectionIsRTL {
            SideMenuManager.default.rightMenuNavigationController = menuNavigationController
        } else {
            SideMenuManager.default.leftMenuNavigationController = menuNavigationController
        }
        
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: rootTabBarController.view, forMenu: layoutDirectionIsRTL ? .right : .left)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.backgroundColor = .background
        window?.windowScene = windowScene
        window?.rootViewController = rootViewController
		window?.overrideUserInterfaceStyle = InterfaceStyleConstants[UserDefaultsManager.interfaceStyleId ?? 0]!
        window?.makeKeyAndVisible()
    }
}

