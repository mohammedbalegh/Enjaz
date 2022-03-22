import UIKit

class UsernameTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 2
		canStartWithNumber = false
		
        fieldName = "Username".localized
		textField.textContentType = .username
		icon.image = UIImage(named: "personIcon")
		validator = RegexValidator.validateUsername
		defaultErrorMessage = "Incorrect username".localized
	}
}
