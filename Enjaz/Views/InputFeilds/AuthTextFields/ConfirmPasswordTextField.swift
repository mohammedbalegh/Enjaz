import UIKit

class ConfirmPasswordTextField: AuthTextField {
	
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
		icon.image = UIImage(named: "lockIcon")
		defaultErrorMessage = "كلمتي السر غير متطابقين"
	}
	
    func validate(password: String?) -> Bool {
		guard let password = password else { return false }
		
		if text != password {
			showErrorMessage()
			return false
		}
		
		return validate()
	}
}
