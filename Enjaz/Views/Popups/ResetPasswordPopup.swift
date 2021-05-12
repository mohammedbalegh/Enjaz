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
	
	override func setupContentView() {
		contentView.backgroundColor = .accent
		contentView.layer.cornerRadius = 20
		
		NSLayoutConstraint.activate([
			contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
			contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
			contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
			contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
		])
	}
	
	func setupSuccessImage() {
		contentView.addSubview(successImage)
		
		NSLayoutConstraint.activate([
			successImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
			successImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			successImage.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
			successImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
		])
	}
	
	func setupLabel() {
		contentView.addSubview(label)
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 10),
			label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			label.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
		])
	}
	
	func setupBackToLoginBtn() {
		contentView.addSubview(backToLoginBtn)
		
		let buttonHeight: CGFloat = 50
		
		backToLoginBtn.layer.cornerRadius = buttonHeight / 2
		
		backToLoginBtn.layer.borderWidth = 1
		backToLoginBtn.layer.borderColor = UIColor.white.cgColor
		    
		NSLayoutConstraint.activate([
			backToLoginBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
			backToLoginBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			backToLoginBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
			backToLoginBtn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
		])
	}

}
