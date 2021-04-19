import UIKit

class SignupScreenVC: AuthScreenVC {
    
    var previousScreenIsLoginScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = NSLocalizedString("Create an account", comment: "")
        subTitleLabel.text = NSLocalizedString("Enter your account details", comment: "")
        authenticationBtn.setTitle(NSLocalizedString("Create an account", comment: ""), for: .normal)
        otherAuthMethodLabel.text = NSLocalizedString("Already have an account?", comment: "")
        otherAuthMethodBtn.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
    }
    
    // MARK: Event Handlers
    
    override func handleAuthenticationBtnTap() {
        dismissKeyboard()
        
        let allInputsAreValid = validateInputs()
        guard allInputsAreValid else { return }
        
        let name = nameTextField.text
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let user = UserModel(id: -1, name: name, username: username, email: email, my_msg: "", my_view: "", about_me: "")
        
        guard isConnectedToInternet else {
            alertPopup.presentAsInternetConnectionError()
            return
        }
        
        view.isUserInteractionEnabled = false
        authenticationBtn.isLoading = true
        
        Auth.signup(user: user, password: password) { (newUser, error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.authenticationBtn.isLoading = false
                
                if let error = error {
                    print(error)
                    self.alertPopup.presentAsError(withMessage: "اسم المستخدم أو البريد الإلكتروني مسجل بالفعل")
                    return
                }
                
                guard let newUser = newUser else { return }
                
                UserDefaultsManager.user = newUser
                UserDefaultsManager.isLoggedIn = true
                self.navigateToEmailVerificationScreen()
            }
        }
    }
    
    override func handleOtherAuthMethodBtnTap() {
        navigateToLoginVC()
    }
    
    // MARK: Tools
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        let arrangedSubviews = [nameTextField, usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        
        return arrangedSubviews
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
    
    func navigateToEmailVerificationScreen() {
        let emailVerificationScreenVC = EmailVerificationScreenVC()
        emailVerificationScreenVC.password = passwordTextField.text
        emailVerificationScreenVC.email = emailTextField.text
        
        navigationController?.pushViewController(emailVerificationScreenVC, animated: true)
    }
    
}
