import UIKit

class NewAdditionTextField: UITextField {
	// MARK: Properties
		
	var fieldName = ""
	var height: CGFloat = LayoutConstants.inputHeight
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(fieldName: String, height: CGFloat? = nil) {
		super.init(frame: .zero)
		self.fieldName = fieldName
		if let height = height {
			self.height = height
		}
	}
	
	override func didMoveToWindow() {
		guard window != nil else { return }
		
		setUp()
	}
	
	// MARK: View Setups
	
	func setUp() {
		placeholder = fieldName
		setTextFieldDirectionToMatchSuperView()
	}
	
	// MARK: Tools
	
	func validate() -> Bool {
		guard let text = text else { return false }
		
		if text.count == 0 {
			showErrorMessage(errorMessage: "\(fieldName) cannot be left blank")
			return false
		}
		
		return true
	}
	
	func showErrorMessage(errorMessage: String) {
		setPlaceholder(errorMessage)
	}
	
	@objc func hideErrorMessage() {
		setPlaceholder(fieldName)
	}
}
