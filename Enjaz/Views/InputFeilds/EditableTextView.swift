import UIKit

class EditableTextView: UITextView, UITextViewDelegate {
	
	var placeholder = "" {
		didSet {
            if textColor == .placeholderColor {
				text = placeholder
			}
		}
	}
    
    var textViewDidUpdateFocus: ((_ focused: Bool) -> Void)?
	
	init(frame: CGRect) {
		super.init(frame: frame, textContainer: nil)
		
        overrideUserInterfaceStyle = .light
		backgroundColor = .clear
		delegate = self
		isEditable = true
		textAlignment = .right
		textColor = .placeholderColor
        textContainerInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
		
	// MARK: Delegate
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.placeholderColor {
			textView.text = nil
			textView.textColor = UIColor.black
		}
        
        textViewDidUpdateFocus?(true)
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = placeholder
			textView.textColor = UIColor.placeholderColor
		}
        
        textViewDidUpdateFocus?(false)
	}
	
}
