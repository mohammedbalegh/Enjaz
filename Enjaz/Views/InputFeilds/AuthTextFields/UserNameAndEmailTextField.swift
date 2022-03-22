import UIKit

class UserNameAndEmailTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 6
		canStartWithNumber = false
		
		fieldName = "Username or Email".localized
		textField.textContentType = .username
		icon.image = UIImage(named: "personIcon")
		defaultErrorMessage = "Incorrect username or email".localized
	}
}
