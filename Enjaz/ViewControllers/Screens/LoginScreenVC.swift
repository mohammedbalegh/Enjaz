import UIKit

class LoginScreenVC: AuthScreenVC {
    
	let usernameAndEmailTextField = UserNameAndEmailTextField()
	
    let forgotPasswordBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Forgot your password?".localized, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handleForgotPasswordBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        titleLabel.text = "Login".localized
        subTitleLabel.text = "Enter your username and password".localized
        authenticationBtn.setTitle("Login".localized, for: .normal)
        otherAuthMethodLabel.text = "Not an existing user?".localized
        otherAuthMethodBtn.setTitle("Create an account".localized, for: .normal)
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
        
        let username = usernameAndEmailTextField.text
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
                    self.alertPopup.presentAsError(withMessage: "Incorrect username or password".localized)
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
        let arrangedSubviews = [usernameAndEmailTextField, passwordTextField]
        return arrangedSubviews
    }
    
    func alterAuthenticationBtnTopAnchorConstraint() {
        authenticationBtnTopAnchorConstraint.isActive = false
        authenticationBtn.topAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.045).isActive = true
    }
    
    func navigateToSignupScreen() {
        if previousViewController is SignupScreenVC {
            navigationController?.popViewController(animated: true)
            return
        }
        
        navigationController?.pushViewController(SignupScreenVC(), animated: true)
    }
    
    func navigateToPasswordResetScreen() {
        navigationController?.pushViewController(PasswordResetScreenVC(), animated: true)
    }
    
    func navigateToMainTabBarController() {
		dismiss(animated: true)
    }
    
    func navigateToEmailVerificationScreen() {
        let emailVerificationScreenVC = EmailVerificationScreenVC()
        emailVerificationScreenVC.password = passwordTextField.text
        emailVerificationScreenVC.email = emailTextField.text
        
        navigationController?.pushViewController(emailVerificationScreenVC, animated: true)
    }
    
}

