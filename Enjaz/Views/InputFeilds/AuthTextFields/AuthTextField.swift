import UIKit

class AuthTextField : UIView {
	// MARK: Properties
	
	var textField = UITextField()
	var icon = UIImageView()
    var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = .red
        
        return label
    }()
	var textFieldContainer = UIView()
	
	var fieldName = ""
	lazy var fieldNounName = fieldName // This property is used when the filed name is required in a sentence as a noun and not as a verb (like the error label)
	var minimumLength = 8
	var canStartWithNumber = true
	var defaultErrorMessage: String?
	var validator: ((String) -> Bool)?
	
	let height: CGFloat = max(LayoutConstants.screenHeight * 0.085, 50)
	let iconHorizontalMargin: CGFloat = 12
	let errorLabelHeight: CGFloat = 12
	
	var text: String {
		return textField.text ?? ""
	}
		
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init() {
		super.init(frame: .zero)
	}
	
	override func didMoveToWindow() {
		guard window != nil else { return }
		
		setUp()
		setupErrorLabel()
		setupTextFieldContainer()
		setupIcon()
		setupTextField()
	}
	
	// MARK: View Setups
	
	func setUp() {
		translatesAutoresizingMaskIntoConstraints = false
		
		heightAnchor.constraint(equalToConstant: height).isActive = true
	}
	
	func setupErrorLabel() {
		addSubview(errorLabel)
		
		NSLayoutConstraint.activate([
			errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
			errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			errorLabel.heightAnchor.constraint(equalToConstant: errorLabelHeight),
		])
	}
	
	func setupTextFieldContainer() {
		addSubview(textFieldContainer)
		textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
		
		let containerHeight = height - errorLabelHeight
		textFieldContainer.layer.cornerRadius = containerHeight / 2
		
		textFieldContainer.applyLightShadow()
		
		textFieldContainer.backgroundColor = .white
		
		NSLayoutConstraint.activate([
			textFieldContainer.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 3),
			textFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
			textFieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
			textFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
	}
	
	func setupIcon() {
		addSubview(icon)
		icon.translatesAutoresizingMaskIntoConstraints = false
		
		icon.contentMode = .scaleAspectFit
		
		NSLayoutConstraint.activate([
			icon.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
			icon.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: iconHorizontalMargin),
			icon.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor, multiplier: 0.4),
			icon.widthAnchor.constraint(equalToConstant: 25),
		])
	}
	
	func setupTextField() {
		addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false
		
        textField.placeholder = fieldName
		setTextFieldDirection()
		
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor),
			textField.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: iconHorizontalMargin),
			textField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor),
			textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: 5),
		])
		
		textField.addTarget(self, action: #selector(hideErrorMessage), for: .allEditingEvents)
	}
	
	// MARK: Tools
	
	func setTextFieldDirection() {
		let layoutDirection = getCurrentLayoutDirectionFor(self)
		if layoutDirection == .rightToLeft {
			textField.textAlignment = .right
		}
	}
	
	func validate() -> Bool {
		if text.count == 0 {
			showErrorMessage(errorMessage: "\(fieldNounName) لا يمكن أن يتُرك فارغاً")
			return false
		}
		
		if !canStartWithNumber && Character(text[0]).isNumber {
			showErrorMessage(errorMessage: "\(fieldNounName) لا يمكن أن يبدأ برقم")
			return false
		}
		
		if text.count < minimumLength {
			showErrorMessage(errorMessage: "\(fieldNounName) يجب أن يكون \(minimumLength) حرف على الأقل")
			return false
		}

		guard let validator = validator else { return true }
		
		let inputIsValid = validator(text)
		
		if !inputIsValid {
			showErrorMessage()
			return false
		}
		
		return true
	}
	
	func showErrorMessage(errorMessage: String? = nil) {
		if let errorMessage = errorMessage {
			errorLabel.text = errorMessage
			return
		}
		
		if let defaultErrorMessage = defaultErrorMessage {
			errorLabel.text = defaultErrorMessage
		}
	}
	
	@objc func hideErrorMessage() {
		errorLabel.text = ""
	}
}
