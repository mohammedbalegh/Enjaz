import UIKit

class NewAdditionTextField: UITextField, NewAdditionInputFieldContainerInput {
    
	var fieldName = ""
	var height: CGFloat = LayoutConstants.inputHeight
    
    var inputText: String? {
        get { return text }
        set { text = newValue }
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(fieldName: String, height: CGFloat? = nil) {
		super.init(frame: .zero)
		self.fieldName = fieldName
		if let height = height {
			self.height = height
		}
        
        placeholder = fieldName
	}
	
	override func didMoveToWindow() {
		guard window != nil else { return }
		
        setTextFieldDirectionToMatchSuperView()
	}
        
}
