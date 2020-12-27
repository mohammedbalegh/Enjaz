import UIKit

class PasswordTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 8
		
		fieldName = "الرمز السري"
		textField.textContentType = .password
		textField.isSecureTextEntry = true
		icon.image = #imageLiteral(resourceName: "lockIcon")
	}
}
