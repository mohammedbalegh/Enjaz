import UIKit

class NewPasswordTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 8
		
		fieldName = "الرمز السري الجديد"
		textField.textContentType = .password
		textField.isSecureTextEntry = true
		icon.image = #imageLiteral(resourceName: "lockIcon")
		validator = RegexValidator.validatePassword
		defaultErrorMessage = "Password must contain a special character"
	}
}
