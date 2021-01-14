import UIKit

class LoginScreenVC: AuthScreenBaseVC {
    
    let forgotPasswordBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("نسيت كلمة السر؟", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
        button.titleLabel?.font = .systemFont(ofSize: fontSize)
        button.addTarget(self, action: #selector(onForgotPasswordTap), for: .touchUpInside)
        
        return button
    }()
    
    var previousScreenIsSignupScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "تسجيل الدخول"
        subTitleLabel.text = "ادخل اسم المستخدم و كلمة السر"
        authenticationBtn.setTitle("تسجيل الدخول", for: .normal)
        otherAuthMethodLabel.text = "لم تشترك بعد؟"
        otherAuthMethodBtn.setTitle("إنشاء حساب", for: .normal)
    }
        
    override func setupSubViews() {
        super.setupSubViews()
        setupForgotPasswordBtn()
        
        alterAuthenctacionBtnTopAnchorConstraint()
    }
    
    func setupForgotPasswordBtn() {
        view.addSubview(forgotPasswordBtn)
        
        NSLayoutConstraint.activate([
            forgotPasswordBtn.topAnchor.constraint(equalTo: textFieldsVerticalStack.bottomAnchor, constant: LayoutConstants.screenHeight * 0.02),
            forgotPasswordBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordBtn.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            forgotPasswordBtn.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    // MARK: Event Handlers
    
    override func onAuthenticationBtnTap() {
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
        authenticationBtn.isLoading = true
        
        Auth.login(username: username, password: password) { (user, error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.authenticationBtn.isLoading = false
                
                if let error = error {
                    print(error)
                    self.alertPopup.showAsError(withMessage: "اسم المستخدم أو كلمة السر غير صحيحين")
                    return
                }
                
                guard let user = user else { return }
                
                UserDefaultsManager.user = user
                UserDefaultsManager.isLoggedIn = true
                
                self.navigateToMainTabBarController()
            }
        }
    }
        
    override func onOtherAuthMethodBtnTap() {
        navigateToSignupScreen()
    }
    
    @objc func onForgotPasswordTap() {
        navigateToPasswordResetScreen()
    }
    
    // MARK: Tools
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        let arrangedSubviews = [usernameTextField, passwordTextField]
        return arrangedSubviews
    }
    
    func alterAuthenctacionBtnTopAnchorConstraint() {
        authenticationBtnTopAnchorConstraint.isActive = false
        authenticationBtn.topAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.045).isActive = true
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
    
    func navigateToMainTabBarController() {
        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
    
    func navigateToEmailVerificationScreen() {
        let emailVerificationScreenVC = EmailVerificationScreenVC()
        emailVerificationScreenVC.password = passwordTextField.text
        emailVerificationScreenVC.email = emailTextField.text
        
        navigationController?.pushViewController(emailVerificationScreenVC, animated: true)
    }
    
}

