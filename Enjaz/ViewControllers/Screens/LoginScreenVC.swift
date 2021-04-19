import UIKit

class LoginScreenVC: AuthScreenVC {
    
    let forgotPasswordBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(NSLocalizedString("Forgot your password?", comment: ""), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
        button.titleLabel?.font = .systemFont(ofSize: fontSize)
        button.addTarget(self, action: #selector(handleForgotPasswordBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    var previousScreenIsSignupScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = NSLocalizedString("Login", comment: "")
        subTitleLabel.text = NSLocalizedString("Enter your username and password", comment: "")
        authenticationBtn.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        otherAuthMethodLabel.text = NSLocalizedString("Not an existing user?", comment: "")
        otherAuthMethodBtn.setTitle(NSLocalizedString("Create an account", comment: ""), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func setupSubViews() {
        super.setupSubViews()
        setupForgotPasswordBtn()
        
        alterAuthenticationBtnTopAnchorConstraint()
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
    
    override func handleAuthenticationBtnTap() {
        dismissKeyboard()
        
        let allInputsAreValid = validateInputs()
        guard allInputsAreValid else { return }
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        guard isConnectedToInternet else {
            alertPopup.presentAsInternetConnectionError()
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
                    self.alertPopup.presentAsError(withMessage: NSLocalizedString("Incorrect username or password", comment: ""))
                    return
                }
                
                guard let user = user else { return }
                
                UserDefaultsManager.user = user
                UserDefaultsManager.isLoggedIn = true
                
                self.navigateToMainTabBarController()
            }
        }
    }
        
    override func handleOtherAuthMethodBtnTap() {
        navigateToSignupScreen()
    }
    
    @objc func handleForgotPasswordBtnTap() {
        navigateToPasswordResetScreen()
    }
    
    // MARK: Tools
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        let arrangedSubviews = [usernameTextField, passwordTextField]
        return arrangedSubviews
    }
    
    func alterAuthenticationBtnTopAnchorConstraint() {
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

