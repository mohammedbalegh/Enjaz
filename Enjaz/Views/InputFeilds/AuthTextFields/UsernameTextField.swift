import UIKit

class UsernameTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 6
		canStartWithNumber = false
		
		fieldName = "اسم المستخدم"
		textField.textContentType = .username
		icon.image = UIImage(named: "personIcon")
		validator = RegexValidator.validateUsername
		defaultErrorMessage = "اسم المستخدم غير صحيح"
	}
}
