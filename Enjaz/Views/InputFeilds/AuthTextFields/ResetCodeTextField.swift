import UIKit

class ResetCodeTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		// The length is checked by the validator and a custom error label is shown, if the check fails.
		minimumLength = 0
        // TODO: Localization
		fieldName = "الكود"
		textField.textContentType = .oneTimeCode
		textField.keyboardType = .numberPad
		icon.image = UIImage(named: "lockIcon")
		validator = RegexValidator.validateResetCode
		defaultErrorMessage = "الرمز مكون من ٦ أحرف"
	}
}
