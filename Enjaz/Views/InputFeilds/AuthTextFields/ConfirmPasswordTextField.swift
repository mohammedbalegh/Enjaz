import UIKit

class ConfirmPasswordTextField: AuthTextField {
	var password: String?
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 8
		
		fieldName = "تأكيد الرمز السري"
		fieldNounName = "تأكيد الرمز السري"
		textField.textContentType = .password
		textField.isSecureTextEntry = true
		icon.image = #imageLiteral(resourceName: "lockIcon")
		defaultErrorMessage = "Passwords do not match"
	}
	
	override func validate() -> Bool {
		guard let password = password else { return false }
		
		if text != password {
			showErrorMessage()
			return false
		}
		
		return super.validate()
	}
}
