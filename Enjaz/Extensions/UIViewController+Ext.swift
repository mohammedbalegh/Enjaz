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
        view.translateViewVertically(by: keyBoardHeight)
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
        view.resetViewVerticalTranslation()
	}
	
	
	func dismissKeyboardOnTextFieldBlur() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
}
