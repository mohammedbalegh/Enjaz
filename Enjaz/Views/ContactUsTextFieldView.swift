import UIKit

class ContactUsTextFieldView: UIView, UITextViewDelegate {
    
    var placeholder = "" {
        didSet {
            if inputTextView.textColor == .placeholderText {
                inputTextView.text = placeholder
            }
        }
    }
        
    var inputText: String? {
        get {
            return inputTextView.text == placeholder ? "" : inputTextView.text
        }
        set {
            if (newValue ?? "").isEmpty {
                setPlaceholder(inputTextView.self)
                return
            }
            
            inputTextView.text = newValue
        }
    }
    
    var customDelegate: UITextViewDelegate?

    let titleLabel: UILabel = {
        let text = UILabel()
        text.backgroundColor = .clear
        text.font = .systemFont(ofSize: 20)
        text.textColor = .lightGray
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let inputTextView: UITextView = {
        let text = UITextView()
        
        text.sizeToFit()
        text.textColor = UIColor.placeholderText
        text.font = .systemFont(ofSize: 20)
        text.layer.cornerRadius = 8
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.placeholderText.cgColor
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        
        inputTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupTextView()
        setupTextField()
    }
    
    func setupTextField() {
        addSubview(inputTextView)
        
        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupTextView() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0303)
        ])
    }
    
    func setPlaceholder(_ textView: UITextView) {
        inputTextView.setTextViewDirectionToMatchSuperView()
        textView.text = placeholder
        textView.textColor = .placeholderText
    }
        
    // MARK: Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .black
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
