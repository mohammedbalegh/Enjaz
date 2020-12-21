import UIKit

class EditableTextView: UITextView, UITextViewDelegate {
	
	var placeholder = "" {
		didSet {
			if textColor == .lightGray {
				text = placeholder
			}
		}
	}
	
	init(frame: CGRect) {
		super.init(frame: frame, textContainer: nil)
		
		backgroundColor = .clear
		delegate = self
		isEditable = true
		textAlignment = .right
		textColor = .lightGray
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
		
	// MARK: Delegate
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = placeholder
			textView.textColor = UIColor.lightGray
		}
	}
	
}
