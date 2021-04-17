import UIKit

class EmailTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 0

		fieldName = NSLocalizedString("Email", comment: "")
		textField.textContentType = .emailAddress
		textField.keyboardType = .emailAddress
		icon.image = UIImage(named: "emailIcon")
		validator = RegexValidator.validateEmail
		defaultErrorMessage = NSLocalizedString("Incorrect email", comment: "")
	}
}

