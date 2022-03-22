import UIKit

class ConfirmPasswordTextField: AuthTextField {
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 8
		
		fieldName = "Confirm password".localized
		fieldNounName = "Confirm password".localized
		textField.textContentType = .password
		textField.isSecureTextEntry = true
		icon.image = UIImage(named: "lockIcon")
		defaultErrorMessage = "The password does not match".localized
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
