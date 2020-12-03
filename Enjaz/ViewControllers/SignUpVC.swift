import UIKit

class SignUpVC: UIViewController {
    // MARK: Properties
	var appLogo = AppLogo(frame: .zero)
	var titleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "إنشاء حساب"
		label.font = UIFont.systemFont(ofSize: 27)
		
		label.textColor = .accentColor
		return label
	}()
	
	var subTitleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "ادخل بيانات الحساب"
		label.font = UIFont.systemFont(ofSize: 22)
		label.textColor = .gray
		return label
	}()
	
	var nameTextField = AuthTextField(type: .name, canStartWithNumber: false)
	var usernameTextField = AuthTextField(type: .username, minimumLength: 8, canStartWithNumber: false)
	var emailTextField = AuthTextField(type: .email)
	var passwordTextField = AuthTextField(type: .password, minimumLength: 8)
	var confirmPasswordTextField = AuthTextField(type: .confirmPassword, minimumLength: 8)
	
	
	let textFieldsTopMargin: CGFloat = 8
	
	// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
		setupSubViews()
    }
	
	// MARK: SubViews Setups
	func setupSubViews() {
		setupAppLogo()
		setupTitleLabel()
		setupSubTitleLabel()
		setupNameTextField()
		setupUsernameTextField()
		setupEmailTextField()
		setupPasswordTextField()
		setupConfirmPasswordTextField()
	}
	
	func setupAppLogo() {
		appLogo.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(appLogo)
		
		appLogo.contentMode = .scaleAspectFit
		NSLayoutConstraint.activate([
			appLogo.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth),
			appLogo.heightAnchor.constraint(equalToConstant: 85),
			appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			appLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.05)
		])
	}
	
	func setupTitleLabel() {
		view.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: LayoutConstants.screenHeight * 0.1)
		])
	}
	
	func setupSubTitleLabel() {
		view.addSubview(subTitleLabel)
		
		NSLayoutConstraint.activate([
			subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
		])
	}
	
	func setupNameTextField() {
		view.addSubview(nameTextField)
		nameTextField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30).isActive = true
	}
	
	func setupUsernameTextField() {
		view.addSubview(usernameTextField)
		usernameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: textFieldsTopMargin).isActive = true
	}
	
	func setupEmailTextField() {
		view.addSubview(emailTextField)
		emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: textFieldsTopMargin).isActive = true
	}
	
	func setupPasswordTextField() {
		view.addSubview(passwordTextField)
		passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldsTopMargin).isActive = true
	}
	
	func setupConfirmPasswordTextField() {
		view.addSubview(confirmPasswordTextField)
		confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: textFieldsTopMargin).isActive = true
	}

}
