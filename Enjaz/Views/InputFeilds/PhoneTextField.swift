import UIKit

class PhoneTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = .placeholderText
        keyboardType = .asciiCapableNumberPad
        
        layer.cornerRadius = 8
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.placeholderText.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
