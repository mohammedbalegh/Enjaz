import Foundation
import UIKit

extension UIViewController {
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
    func focusOnNextTextFieldOnPressReturn(from textField: UITextField) {
        // Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes then move the cursor to that next text-field. If no then dismiss the keyboard
        if let nextField = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
}
