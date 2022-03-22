import UIKit

class EmailTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 0

		fieldName = "Email".localized
		textField.textContentType = .emailAddress
		textField.keyboardType = .emailAddress
		icon.image = UIImage(named: "emailIcon")
		validator = RegexValidator.validateEmail
		defaultErrorMessage = "Incorrect email".localized
	}
}

