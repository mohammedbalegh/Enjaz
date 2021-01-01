import UIKit
import Network
import ReSwift

class SignupScreenVC: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
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
    var googleOAuthBtn = OAuthBtn(type: .google)
	lazy var oAuthBtnsHSV: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [appleOAuthBtn, twitterOAuthBtn])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.spacing = 15
		return stackView
	}()
    let alertPopup = AlertPopup(hideOnOverlayTap: true)
    
    var isConnectedToInternet = false
    var previousScreenIsLoginScreen = false
	
    func newState(state: AppState) {
        self.isConnectedToInternet = state.isConnectedToInternet
    }
    
	// MARK: Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        store.subscribe(self)
        
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
        
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        confirmPasswordTextField.textField.delegate = self
	}
	
	func setupSignupBtn() {
		view.addSubview(signupBtn)
		signupBtn.translatesAutoresizingMaskIntoConstraints = false
        
		NSLayoutConstraint.activate([
			signupBtn.topAnchor.constraint(equalTo: textFieldsVSV.bottomAnchor, constant: LayoutConstants.screenHeight * 0.025),
			signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
        
        signupBtn.addTarget(self, action: #selector(onSignupBtnTap), for: .touchUpInside)
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
	    
    @objc func onSignupBtnTap() {
        dismissKeyboard()
        
        let allInputsAreValid = validateInputs()
        guard allInputsAreValid else { return }
        
        let name = nameTextField.text
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let user = UserModel(id: -1, name: name, username: username, email: email, my_msg: "", my_view: "", about_me: "")
                
        guard isConnectedToInternet else {
            alertPopup.showAsInternetConnectionError()
            return
        }
        
        view.isUserInteractionEnabled = false
        signupBtn.isLoading = true
        
        Auth.signup(user: user, password: password) { (newUser, error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.signupBtn.isLoading = false
                
                if let error = error {
                    print(error)
                    self.alertPopup.showAsError(withMessage: "اسم المستخدم أو البريد الإلكتروني مسجل بالفعل")
                    return
                }
                
                guard let newUser = newUser else { return }
                
                self.saveUserDataToUserDefaults(newUser)
                self.navigateToEmailVerificationScreen()
            }
        }
    }
    
	@objc func onLoginTap() {
		navigateToLoginVC()
	}
	
	//MARK: Tools
	
    func validateInputs() -> Bool {
        let nameIsValid = nameTextField.validate()
        let usernameIsValid = usernameTextField.validate()
        let emailIsValid = emailTextField.validate()
        let passwordIsValid = passwordTextField.validate()
        let passwordConfirmationIsValid = confirmPasswordTextField.validate(password: passwordTextField.text)
        
        let allInputsAreValid = nameIsValid && usernameIsValid && emailIsValid && passwordIsValid && passwordConfirmationIsValid
        
        return allInputsAreValid
    }
        
	func navigateToLoginVC() {
        if previousScreenIsLoginScreen {
            navigationController?.popViewController(animated: true)
            return
        }
        
        let loginScreen = LoginScreenVC()
        loginScreen.previousScreenIsSignupScreen = true
        
        navigationController?.pushViewController(loginScreen, animated: true)
	}
    
    func saveUserDataToUserDefaults(_ newUser: UserModel) {
        UserDefaultsManager.setUser(user: newUser)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
        UserDefaults.standard.synchronize()
    }
    
    func navigateToEmailVerificationScreen() {
        let emailVerificationScreenVC = EmailVerificationScreenVC()
        emailVerificationScreenVC.password = passwordTextField.text
        emailVerificationScreenVC.email = emailTextField.text
        
        navigationController?.pushViewController(emailVerificationScreenVC, animated: true)
    }
}


extension SignupScreenVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.translateViewVertically(by: LayoutConstants.screenHeight * 0.25)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.resetViewVerticalTranslation()
    }
}
