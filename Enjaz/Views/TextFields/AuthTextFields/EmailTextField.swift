import UIKit

class EmailTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 8

		fieldName = "البريد الإلكتروني"
		textField.textContentType = .emailAddress
		textField.keyboardType = .emailAddress
		icon.image = #imageLiteral(resourceName: "emailIcon")
		validator = RegexValidator.validateEmail
		defaultErrorMessage = "Email is invalid"
	}
}

