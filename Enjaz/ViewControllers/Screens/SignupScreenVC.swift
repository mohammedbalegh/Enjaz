import UIKit

class SignupScreenVC: UIViewController {
    // MARK: Properties
	
	var appLogo = AppLogo(frame: .zero)
	var titleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "إنشاء حساب"
		let fontSize: CGFloat = max(23, LayoutConstants.screenHeight * 0.025)
		label.font = UIFont.systemFont(ofSize: fontSize)
		label.textColor = .accentColor
		return label
	}()
	var subTitleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "ادخل بيانات الحساب"
		let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
		label.font = UIFont.systemFont(ofSize: fontSize)
		label.textColor = .gray
		return label
	}()
	var nameTextField = NameTextField()
	var usernameTextField = UsernameTextField()
	var emailTextField = EmailTextField()
	var passwordTextField = PasswordTextField()
	var confirmPasswordTextField = ConfirmPasswordTextField()
	var signupBtn = PrimaryBtn(label: "إنشاء حساب", theme: .blue, size: .large)
	lazy var textFieldsVSV: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [nameTextField, usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 3
		return stackView
	}()
	var alreadyHaveAccountLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "لديك حساب بالفعل؟"
		label.textColor = .gray
		return label
	}()
	var loginBtn: UIButton = {
		var button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle("تسجيل الدخول", for: .normal)
		button.setTitleColor(.accentColor, for: .normal)
		
		button.addTarget(self, action: #selector(onLoginTap), for: .touchUpInside)
		
		return button
	}()
	lazy var loginLabelAndBtnHSV : UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [alreadyHaveAccountLabel, loginBtn])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillProportionally
		stackView.spacing = 5
		return stackView
	}()
	var appleOAuthBtn = OAuthBtn(type: .apple)
	var twitterOAuthBtn = OAuthBtn(type: .twitter)
	lazy var oAuthBtnsHSV: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [appleOAuthBtn, twitterOAuthBtn])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.spacing = 15
		return stackView
	}()
	
	// MARK: Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
		dismissKeyboardOnTextFieldBlur()
		setupSubViews()
    }
	
	// MARK: SubViews Setups
	func setupSubViews() {
		setupAppLogo()
		setupTitleLabel()
		setupSubTitleLabel()
		setupTextFieldsVSV()
		setupSignupBtn()
		setupLoginLabelAndBtnHSV()
		setupOAuthBtnsHSV()
	}
	
	func setupAppLogo() {
		appLogo.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(appLogo)
		
		appLogo.contentMode = .scaleAspectFit
		NSLayoutConstraint.activate([
			appLogo.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
			appLogo.heightAnchor.constraint(equalToConstant: 85),
			appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			appLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4)
		])
	}
	
	func setupTitleLabel() {
		view.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: LayoutConstants.screenHeight * 0.065)
		])
	}
	
	func setupSubTitleLabel() {
		view.addSubview(subTitleLabel)
		
		NSLayoutConstraint.activate([
			subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
		])
	}
	
	func setupTextFieldsVSV() {
		view.addSubview(textFieldsVSV)
		
		NSLayoutConstraint.activate([
			textFieldsVSV.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
			textFieldsVSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			textFieldsVSV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
			textFieldsVSV.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
		])
	}
	
	func setupSignupBtn() {
		view.addSubview(signupBtn)
		signupBtn.translatesAutoresizingMaskIntoConstraints = false
				
		NSLayoutConstraint.activate([
			signupBtn.topAnchor.constraint(equalTo: textFieldsVSV.bottomAnchor, constant: LayoutConstants.screenHeight * 0.025),
			signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			signupBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
		])
	}

	func setupLoginLabelAndBtnHSV() {
		view.addSubview(loginLabelAndBtnHSV)
		NSLayoutConstraint.activate([
			loginLabelAndBtnHSV.topAnchor.constraint(equalTo: signupBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.025),
			loginLabelAndBtnHSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loginLabelAndBtnHSV.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
			loginLabelAndBtnHSV.heightAnchor.constraint(equalToConstant: 15),
		])
	}
	
	func setupOAuthBtnsHSV() {
		view.addSubview(oAuthBtnsHSV)
		
		NSLayoutConstraint.activate([
			oAuthBtnsHSV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
			oAuthBtnsHSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			oAuthBtnsHSV.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
			oAuthBtnsHSV.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
		])
	}
	
	//MARK: Event Handlers
	
	@objc func onLoginTap() {
		navigateToLoginVC()
	}
	
	//MARK: tools
	
	func navigateToLoginVC() {
		navigationController?.popViewController(animated: true)
	}
	
}
