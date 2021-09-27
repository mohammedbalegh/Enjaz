import UIKit

class UserNameAndEmailTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 6
		canStartWithNumber = false
		
		fieldName = NSLocalizedString("Username or Email", comment: "")
		textField.textContentType = .username
		icon.image = UIImage(named: "personIcon")
		defaultErrorMessage = NSLocalizedString("Incorrect username or email", comment: "")
	}
}
