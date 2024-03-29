import Foundation
import UIKit

extension UIViewController {
	var isPresentedModally: Bool {
		let presentingIsModal = presentingViewController != nil
		let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
		let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
		
		return presentingIsModal || presentingIsNavigation || presentingIsTabBar
	}
	
	var previousViewController: UIViewController? {
		guard let navigationControllerVCs = navigationController?.viewControllers, navigationControllerVCs.count >= 2 else {
			return nil
		}
		
		let previousVCIndex = navigationControllerVCs.count - 2
		let previousVC = navigationControllerVCs[previousVCIndex]
		
		return previousVC
	}
	
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func focusOnNextTextFieldOnPressReturn(from textField: UITextField) {
        // Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes then move the cursor to that next text-field. If no then dismiss the keyboard
        let nextView = view.viewWithTag(textField.tag + 1)
        
        if let nextView = nextView, nextView is UITextField || nextView is UITextView {
            nextView.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
}
