import UIKit

class EditableTextView: UITextView, UITextViewDelegate, InputField {
	    
	var placeholder = "" {
		didSet {
            if textColor == .placeholderText {
				text = placeholder
			}
		}
	}
    
    var inputText: String? {
        get {
            return text == placeholder ? "" : text
        }
        set {
            if (newValue ?? "").isEmpty {
                setPlaceholder(self)
                return
            }
            
            textViewDidBeginEditing(self)
            text = newValue
            textViewDidEndEditing(self)
        }
    }
    
    var customDelegate: UITextViewDelegate?
    
	init(frame: CGRect) {
		super.init(frame: frame, textContainer: nil)
		
		backgroundColor = .clear
		delegate = self
		isEditable = true
        setTextViewDirectionToMatchUserInterface()
		
        if placeholder == text {
            textColor = .placeholderText
        }
		
        textContainerInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func setPlaceholder(_ textView: UITextView) {
        setTextViewDirectionToMatchUserInterface()
        textView.text = placeholder
        textView.textColor = .placeholderText
    }
		
	// MARK: Delegate
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == .placeholderText {
			textView.text = nil
			textView.textColor = .invertedSystemBackground
		}
        customDelegate?.textViewDidBeginEditing?(textView)
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {			
            setPlaceholder(textView)
		}
		
        customDelegate?.textViewDidEndEditing?(textView)
	}
	
}
