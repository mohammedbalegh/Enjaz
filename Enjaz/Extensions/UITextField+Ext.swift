import UIKit

extension UITextField {
	func setPlaceholder(_ placeholder: String) {
		var attributedTitle = NSMutableAttributedString()
		
		attributedTitle = NSMutableAttributedString(string:placeholder, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18.0)!])
		attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 110, green: 110, blue: 110, alpha: 0.7), range:NSRange(location:0, length: placeholder.count))
		attributedPlaceholder = attributedTitle
	}
	
	func setTextFieldDirectionToMatchSuperView() {
		let layoutDirection = getCurrentLayoutDirectionFor(self)
		if layoutDirection == .rightToLeft {
			textAlignment = .right
		}
	}
	
	func indentText() {
		let spacerView = UIView(frame:CGRect(x:0, y:0, width:20, height:20))
		leftViewMode = UITextField.ViewMode.always
		leftView = spacerView
	}
}
