import UIKit
import Network
import ReSwift

class LoginScreenVC: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
	// MARK: Properties
	var appLogo = AppLogo(frame: .zero)
	var titleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "تسجيل الدخول"
		let fontSize: CGFloat = max(23, LayoutConstants.screenHeight * 0.025)
		label.font = UIFont.systemFont(ofSize: fontSize)
		label.textColor = .accentColor
		return label
	}()
	var subTitleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "ادخل اسم المستخدم و كلمة السر "
		let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
		label.font = UIFont.systemFont(ofSize: fontSize)
		label.textColor = .gray
		return label
	}()
	var usernameTextField = UsernameTextField()
	var passwordTextField = PasswordTextField()
	var loginBtn = PrimaryBtn(label: "تسجيل الدخول", theme: .blue, size: .large)
	lazy var textFieldsVSV: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 3
		return stackView
	}()
	var forgotPasswordBtn: UIButton = {
		var button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle("نسيت كلمة السر؟", for: .normal)
		button.setTitleColor(.gray, for: .normal)
		let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
		button.titleLabel?.font = .systemFont(ofSize: fontSize)
		button.addTarget(self, action: #selector(onForgotPasswordTap), for: .touchUpInside)
		
		return button
	}()
	var alreadyHaveAccountLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "لم تشترك بعد؟"
		label.textColor = .gray
		return label
	}()
	var signupBtn: UIButton = {
		var button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle("إنشاء حساب", for: .normal)
		button.setTitleColor(.accentColor, for: .normal)
		button.addTarget(self, action: #selector(onSignupTap), for: .touchUpInside)
		
		return button
	}()
	lazy var signupLabelAndBtnHSV : UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [alreadyHaveAccountLabel, signupBtn])
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
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
	
    var isConnectedToInternet = false
    var previousScreenIsSignupScreen = false
    
    
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
		setupForgotPasswordBtn()
		setupLoginBtn()
		setupSignupLabelAndBtnHSV()
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
			appLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
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
	
	func setupForgotPasswordBtn() {
		view.addSubview(forgotPasswordBtn)
		
		NSLayoutConstraint.activate([
			forgotPasswordBtn.topAnchor.constraint(equalTo: textFieldsVSV.bottomAnchor, constant: LayoutConstants.screenHeight * 0.02),
			forgotPasswordBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
	}
	
	func setupLoginBtn() {
		view.addSubview(loginBtn)
		loginBtn.translatesAutoresizingMaskIntoConstraints = false
			
		NSLayoutConstraint.activate([
			loginBtn.topAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.045),
			loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
        
        loginBtn.addTarget(self, action: #selector(onLoginBtnTap), for: .touchUpInside)
	}
	
	func setupSignupLabelAndBtnHSV() {
		view.addSubview(signupLabelAndBtnHSV)
		
		NSLayoutConstraint.activate([
			signupLabelAndBtnHSV.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.025),
			signupLabelAndBtnHSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			signupLabelAndBtnHSV.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
			signupLabelAndBtnHSV.heightAnchor.constraint(equalToConstant: 15),
		])
	}
	
	func setupOAuthBtnsHSV() {
		view.addSubview(oAuthBtnsHSV)
		
		NSLayoutConstraint.activate([
			oAuthBtnsHSV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
			oAuthBtnsHSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			oAuthBtnsHSV.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
			oAuthBtnsHSV.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
		])
	}
	
	// MARK: Event Handlers
        
    @objc func onLoginBtnTap() {
        dismissKeyboard()
        
        let allInputsAreValid = validateInputs()
        guard allInputsAreValid else { return }
        
        let username = usernameTextField.text
        let password = passwordTextField.text
                
        guard isConnectedToInternet else {
            alertPopup.showAsInternetConnectionError()
            return
        }
        
        view.isUserInteractionEnabled = false
        loginBtn.isLoading = true
        
        Auth.login(username: username, password: password) { (user, error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.loginBtn.isLoading = false
                
                if let error = error {
                    print(error)
                    
                        self.alertPopup.showAsError(withMessage: "اسم المستخدم أو كلمة السر غير صحيحين")
                    return
                }
                
                guard let user = user else { return }
                
                self.saveUserDataToUserDefaults(user)
                
                self.navigateToMainTabBarController()
            }
        }
    }
    
	@objc func onSignupTap() {
		navigateToSignupScreen()
	}
	
	@objc func onForgotPasswordTap() {
		navigateToPasswordResetScreen()
	}
	
	// MARK: Tools
    
    func validateInputs() -> Bool {
        let usernameIsValid = usernameTextField.validate()
        let passwordIsValid = passwordTextField.validate()
        
        let allInputsAreValid = usernameIsValid && passwordIsValid
        
        return allInputsAreValid
    }
	
	func navigateToSignupScreen() {
        if previousScreenIsSignupScreen {
            navigationController?.popViewController(animated: true)
            return
        }
        
        let signupScreen = SignupScreenVC()
        signupScreen.previousScreenIsLoginScreen = true
        
		navigationController?.pushViewController(signupScreen, animated: true)
	}
	
	func navigateToPasswordResetScreen() {
		navigationController?.pushViewController(PasswordResetScreenVC(), animated: true)
	}
    
    func saveUserDataToUserDefaults(_ user: UserModel) {
        let encodedUserData = try? NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
        UserDefaults.standard.set(encodedUserData, forKey: UserDefaultsKeys.user)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
        UserDefaults.standard.synchronize()
    }
    
    func navigateToMainTabBarController() {
        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
}
