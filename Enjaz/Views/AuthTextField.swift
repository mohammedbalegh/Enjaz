//
//  AuthTextField.swift
//  TechMall
//
//  Created by Abdelrhman Elmahdy on 3/14/20.
//  Copyright © 2020 Abdelrhman Elmahdy. All rights reserved.
//

import UIKit

class AuthTextField : UIView {
	enum textFieldType: String {
		case username = "اسم المستخدم"
		case password = "الرمز السري"
		case confirmPassword = "تأكيد الرمز السري"
		case name = "الاسم الشخصي (ثنائي)"
		case email = "البريد الإلكتروني"
	}
	
	var textField = UITextField()
	var icon = UIImageView()
	var errorLabel = UILabel()
	
	var type : textFieldType!
	var fieldNounName = "" // This property is used when the filed name is required in a sentence as a noun and not as a verb (like the error label)
	var minimumLength = 1
	var canStartWithNumber = true
	var defaultErrorMessage: String?
	var validator: ((String) -> Bool)?
	let height: CGFloat = 68
	let horizontalMargin: CGFloat = 20
	let iconHorizontalMargin: CGFloat = 12
	var password: String?
	
	var text: String? {
		return textField.text
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUp()
	}
	
	init(type: textFieldType, minimumLength: Int = 1, canStartWithNumber: Bool = true, password: String? = nil) {
		super.init(frame: CGRect(x: 10, y: 0, width: LayoutConstants.screenWidth - horizontalMargin * 2, height: height))
		
		self.type = type
		fieldNounName = type.rawValue
		self.minimumLength = minimumLength
		self.canStartWithNumber = canStartWithNumber
		self.password = password
		
		setUp()
	}
	
	override func didMoveToWindow() {
		if window == nil { return }
		
		setDefaultConstraints()
		setErrorLabelConstraints()
		setIconConstraints()
		setTextFieldConstraints()
		setTextFieldDirection()
	}
	
	func setUp() {
		errorLabel.font = UIFont.systemFont(ofSize: 13)
		errorLabel.textAlignment = .center
		errorLabel.textColor = .red
		
		if type == nil  { return }
		
        var attributedTitle = NSMutableAttributedString()
        let placeholder  = type!.rawValue
        
        attributedTitle = NSMutableAttributedString(string:placeholder, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 16.0)!])
        attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 110, green: 110, blue: 110, alpha: 0.7), range:NSRange(location:0, length: placeholder.count))
        textField.attributedPlaceholder = attributedTitle
        
        
		
		switch type! {
			case .username:
				textField.textContentType = .username
				icon.image = #imageLiteral(resourceName: "presonIcon")
				validator = RegexValidator.validateUsername
				defaultErrorMessage = "Username is invalid"
			
			case .password:
				textField.textContentType = .password
				textField.isSecureTextEntry = true
				icon.image = #imageLiteral(resourceName: "lockIcon")
				validator = RegexValidator.validatePassword
				defaultErrorMessage = "Password must contain a special character"
			case .confirmPassword:
				textField.textContentType = .password
				textField.isSecureTextEntry = true
				icon.image = #imageLiteral(resourceName: "lockIcon")
				defaultErrorMessage = "Passwords do not match"
				fieldNounName = "تأكيد الرمز السري"
			
			case .name:
				textField.textContentType = .name
				icon.image = #imageLiteral(resourceName: "presonIcon")
			
			case .email:
				textField.textContentType = .emailAddress
				textField.keyboardType = .emailAddress
				icon.image = #imageLiteral(resourceName: "emailIcon")
				validator = RegexValidator.validateEmail
				defaultErrorMessage = "Email is invalid"
		}
		
		textField.addTarget(self, action: #selector(hideErrorMessage), for: .allEditingEvents)
		
		addSubview(errorLabel)
		addSubview(icon)
		addSubview(textField)
	}
	
	func setDefaultConstraints() {
		translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			heightAnchor.constraint(equalToConstant: height),
			leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: horizontalMargin),
			rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: -horizontalMargin),
		])
	}
	
	func setErrorLabelConstraints() {
		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
			errorLabel.leftAnchor.constraint(equalTo: leftAnchor),
			errorLabel.heightAnchor.constraint(equalToConstant: 12),
		])
	}
	
	func setIconConstraints() {
		icon.translatesAutoresizingMaskIntoConstraints = false
		icon.contentMode = .scaleAspectFit

		NSLayoutConstraint.activate([
			icon.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
			icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: iconHorizontalMargin),
			icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
			icon.widthAnchor.constraint(equalToConstant: 25),
		])
	}
	
	func setTextFieldConstraints() {
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 2),
			textField.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: iconHorizontalMargin),
			textField.bottomAnchor.constraint(equalTo: bottomAnchor),
			textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
		])
	}
	
	func setTextFieldDirection() {
		let layoutDirection = getCurrentLayoutDirectionFor(self)
		if layoutDirection == .rightToLeft {
			textField.textAlignment = .right
		}
	}
	
	func validate() -> Bool {
		if let type = type, let text = text {
			if text.count == 0 {
				showErrorLabel(errorMessage: "\(fieldNounName) cannot be left blank")
				return false
			}

			if type == .confirmPassword && text != password! {
				showErrorLabel()
			}
			
			if !canStartWithNumber && Character(text[0]).isNumber {
				showErrorLabel(errorMessage: "\(fieldNounName) cannot start with a number")
				return false
			}
			
			if text.count < minimumLength {
				showErrorLabel(errorMessage: "\(fieldNounName) must at least be \(minimumLength) characters")
				return false
			}

			if let validator = validator {
				if !validator(text) {
					showErrorLabel()
					return false
				}
			}

			return true
		}

		return false
	}
	
	func showErrorLabel(errorMessage: String? = nil) {
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
