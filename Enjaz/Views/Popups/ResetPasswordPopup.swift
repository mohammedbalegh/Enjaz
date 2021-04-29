import UIKit

class ResetPasswordPopup: Popup {
	
	var successImage: UIImageView = {
		var imageView = UIImageView(image: UIImage(named: "ResetPasswordSuccessImage"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	var label: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.text = "تم تغيير كلمة المرور بنجاح"
		let fontSize: CGFloat = 20
		label.font = UIFont.systemFont(ofSize: fontSize)
		label.textColor = .secondaryBackground
		
		return label
	}()
	var backToLoginBtn: UIButton = {
		var button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle("الرجوع للتسجيل", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16)
		button.setTitleColor(.secondaryBackground, for: .normal)
		
		return button
	}()
			
	override func setupSubViews() {
		super.setupSubViews()
		setupSuccessImage()
		setupLabel()
		setupBackToLoginBtn()
	}
	
	override func setupPopupContainer() {
		popupContainer.backgroundColor = .accent
		popupContainer.layer.cornerRadius = 20
		
		NSLayoutConstraint.activate([
			popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
			popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
			popupContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
			popupContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
		])
	}
	
	func setupSuccessImage() {
		popupContainer.addSubview(successImage)
		
		NSLayoutConstraint.activate([
			successImage.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: 20),
			successImage.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
			successImage.heightAnchor.constraint(lessThanOrEqualTo: popupContainer.heightAnchor),
			successImage.widthAnchor.constraint(equalTo: popupContainer.widthAnchor, multiplier: 0.5),
		])
	}
	
	func setupLabel() {
		popupContainer.addSubview(label)
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 10),
			label.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
			label.widthAnchor.constraint(lessThanOrEqualTo: popupContainer.widthAnchor, multiplier: 0.9),
		])
	}
	
	func setupBackToLoginBtn() {
		popupContainer.addSubview(backToLoginBtn)
		
		let buttonHeight: CGFloat = 50
		
		backToLoginBtn.layer.cornerRadius = buttonHeight / 2
		
		backToLoginBtn.layer.borderWidth = 1
		backToLoginBtn.layer.borderColor = UIColor.white.cgColor
		    
		NSLayoutConstraint.activate([
			backToLoginBtn.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor, constant: -40),
			backToLoginBtn.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
			backToLoginBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
			backToLoginBtn.widthAnchor.constraint(equalTo: popupContainer.widthAnchor, multiplier: 0.5),
		])
	}

}
