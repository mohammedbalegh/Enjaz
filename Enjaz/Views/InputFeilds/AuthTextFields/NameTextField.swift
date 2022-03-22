import UIKit

class NameTextField: AuthTextField {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init() {
		super.init()
		
		minimumLength = 2
		canStartWithNumber = false

		fieldName = "Full name".localized
		textField.textContentType = .name
		icon.image = UIImage(named: "personIcon")
	}
}
