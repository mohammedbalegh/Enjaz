import Foundation
import UIKit

extension UIViewController {
	
	func enableKeyboardAvoidance() {
		setUpKeyboardObservers()
	}
	
	func setUpKeyboardObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			onKeyboardShown(keyBoardHeight: keyboardSize.height)
		}
	}
	
	@objc func onKeyboardShown(keyBoardHeight: CGFloat) {
		translateViewVertically(by: keyBoardHeight)
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		resetViewVerticalTranslation()
	}
	
	func translateViewVertically(by translation: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y -= translation
        }
	}
	
	func resetViewVerticalTranslation() {
        UIView.animate(withDuration: 0.2) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
	}
	
	func dismissKeyboardOnTextFieldBlur() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
}
