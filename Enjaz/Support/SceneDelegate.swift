import UIKit
import SideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    static var layoutDirectionIsRTL: Bool!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {        
        guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let rootTabBarController = RootTabBarController()
		
        let rootViewController = UINavigationController(rootViewController: rootTabBarController)
        
        let sideMenuVC = SideMenuVC()
        let menuNavigationController = SideMenuNavigationController(rootViewController: sideMenuVC)
        SceneDelegate.layoutDirectionIsRTL = LayoutTools.getCurrentLayoutDirection(for: rootTabBarController.view) == .rightToLeft
        
        if SceneDelegate.layoutDirectionIsRTL {
            SideMenuManager.default.rightMenuNavigationController = menuNavigationController
        } else {
            SideMenuManager.default.leftMenuNavigationController = menuNavigationController
        }
        
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: rootTabBarController.view, forMenu: SceneDelegate.layoutDirectionIsRTL ? .right : .left)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.backgroundColor = .background
        window?.windowScene = windowScene
        window?.rootViewController = rootViewController
		window?.overrideUserInterfaceStyle = InterfaceStyleConstants[UserDefaultsManager.interfaceStyleId ?? 0]!
        window?.makeKeyAndVisible()
    }
}

