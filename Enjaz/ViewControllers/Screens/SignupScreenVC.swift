import UIKit

class SignupScreenVC: AuthScreenVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Create an account".localized
        subTitleLabel.text = "Enter your account details".localized
        authenticationBtn.setTitle("Create an account".localized, for: .normal)
        otherAuthMethodLabel.text = "Already have an account?".localized
        otherAuthMethodBtn.setTitle("Login".localized, for: .normal)
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
        if previousViewController is LoginScreenVC {
            navigationController?.popViewController(animated: true)
            return
        }
        
        navigationController?.pushViewController(LoginScreenVC(), animated: true)
    }
    
    func navigateToEmailVerificationScreen() {
        let emailVerificationScreenVC = EmailVerificationScreenVC()
        emailVerificationScreenVC.password = passwordTextField.text
        emailVerificationScreenVC.email = emailTextField.text
        
        navigationController?.pushViewController(emailVerificationScreenVC, animated: true)
    }
    
}
