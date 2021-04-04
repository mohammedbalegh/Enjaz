import UIKit

class InputFieldContainerTextField: UITextField, InputField {
    var inputText: String? {
        get { return text }
        set { text = newValue }
    }
	
	override func didMoveToWindow() {
		guard window != nil else { return }
        setTextFieldDirectionToMatchSuperView()
	}
        
}
