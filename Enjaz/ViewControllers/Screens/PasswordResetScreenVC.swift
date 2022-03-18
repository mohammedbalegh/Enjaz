import UIKit
import Network
import ReSwift
import SwiftUI

class PasswordResetScreenVC: KeyboardHandlingViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    // MARK: Properties
    
    var lockImage: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "LockImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
		
        label.text = NSLocalizedString("Recover password", comment: "")
        label.font = UIFont.systemFont(ofSize: 25)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.8
		label.textAlignment = .center
        label.textColor = .accent
		
        return label
    }()
    
    var subTitleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = NSLocalizedString("Please Enter your email to send the verification code", comment: "")
		label.font = UIFont.systemFont(ofSize: 18)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.8
		label.textAlignment = .center
        label.textColor = .systemGray
		
        return label
    }()
    
    lazy var emailTextField: EmailTextField = {
        let textField = EmailTextField()
        
        textField.textField.delegate = self
        
        return textField
    }()
    
    lazy var resetCodeTextField: ResetCodeTextField = {
        let textField = ResetCodeTextField()
        
        textField.textField.delegate = self
        textField.textField.tag = 0
        textField.textField.returnKeyType = .next
        
        return textField
    }()
    
    lazy var newPasswordTextField: NewPasswordTextField = {
        let textField = NewPasswordTextField()
        
        textField.textField.delegate = self
        textField.textField.tag = 1
        textField.textField.returnKeyType = .next
        
        return textField
    }()
    
    lazy var confirmPasswordTextField: ConfirmPasswordTextField = {
        let textField = ConfirmPasswordTextField()
        
        textField.textField.delegate = self
        textField.textField.tag = 2
        textField.textField.returnKeyType = .continue
        
        return textField
    }()
    
    lazy var textFieldsVerticalStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [emailTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var nextBtn: PrimaryBtn = {
        var button = PrimaryBtn(label: NSLocalizedString("Next", comment: ""), theme: .blue, size: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleNextBtnTap), for: .touchUpInside)
        return button
    }()
    
    lazy var backBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleBackBtnTap), for: .touchUpInside)
        return button
    }()
    
    lazy var controlBtnsVerticalStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [nextBtn, backBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var resetPasswordPopup: ResetPasswordPopup = {
        let popup = ResetPasswordPopup()
		popup.hideOnOverlayTap = false
        popup.backToLoginBtn.addTarget(self, action: #selector(handlePopupBackToLoginScreenBtnTap), for: .touchUpInside)
        return popup
    }()
    
    let alertPopup = AlertPopup()
    
    var textFieldsVerticalStackHeightConstraint: NSLayoutConstraint!
    
    var isConnectedToInternet = false
    
    func newState(state: AppState) {
        self.isConnectedToInternet = state.isConnectedToInternet
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        store.subscribe(self)
                
        setupSubViews()
    }
    
    // MARK: SubViews Setups
    
    func setupSubViews() {
        setupLockImage()
        setupTitleLabel()
        setupSubTitleLabel()
        setupTextFieldsVerticalStack()
        setupControlBtnsVerticalStack()
    }
    
    func setupLockImage() {
        view.addSubview(lockImage)
        
        NSLayoutConstraint.activate([
            lockImage.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            lockImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            lockImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lockImage.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.07)
        ])
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: lockImage.bottomAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupSubTitleLabel() {
        view.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
			subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupTextFieldsVerticalStack() {
        view.addSubview(textFieldsVerticalStack)
        
        let height = textFieldsVerticalStack.calculateHeightBasedOn(arrangedSubviewHeight: AuthTextField.height)
        
        textFieldsVerticalStackHeightConstraint = textFieldsVerticalStack.heightAnchor.constraint(equalToConstant: height)
        
        NSLayoutConstraint.activate([
            textFieldsVerticalStack.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
            textFieldsVerticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsVerticalStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            textFieldsVerticalStackHeightConstraint,
        ])
    }
    
    func setupControlBtnsVerticalStack() {
        view.addSubview(controlBtnsVerticalStack)
        controlBtnsVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            controlBtnsVerticalStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LayoutConstants.screenHeight * 0.18),
            controlBtnsVerticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlBtnsVerticalStack.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            controlBtnsVerticalStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }
    
    // MARK: Event Handlers
        
    @objc func handleNextBtnTap() {
        let emailIsValid = emailTextField.validate()
        
        guard emailIsValid else { return }
        
        updateSubTitle()
        
        updateNextBtn()
        
        
        updateTextFieldsVerticalStack()
        
        NetworkingManager.requestPasswordResetCode(email: emailTextField.text) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertPopup.present(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("The email you entered does not exist", comment: ""))
                }
            }
        }
    }
    
    // MARK: Event Handlers
    
    @objc func handleStartBtnTap() {
        let allInputsAreValid = validateInputs()
        guard allInputsAreValid else { return }
        
        let resetCode = resetCodeTextField.text
        let email = emailTextField.text
        let newPassword = newPasswordTextField.text
        
        guard isConnectedToInternet else {
            alertPopup.presentAsInternetConnectionError()
            return
        }
        
        Auth.resetPassword(newPassword, email, resetCode) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    self.alertPopup.presentAsError(withMessage: NSLocalizedString("Incorrect code", comment: ""))
                }
                
                self.resetPasswordPopup.present(animated: true)
            }
        }
    }
    
    @objc func handleBackBtnTap() {
        navigateBackToLoginScreen()
    }
    
    @objc func handlePopupBackToLoginScreenBtnTap() {
        resetPasswordPopup.dismiss(animated: true)
        navigateBackToLoginScreen()
    }
    
    // MARK: Tools
    
    func updateNextBtn() {
        nextBtn.setTitle(NSLocalizedString("Start now", comment: ""), for: .normal)
        nextBtn.removeTarget(self, action: #selector(handleNextBtnTap), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(handleStartBtnTap), for: .touchUpInside)
    }
    
    func updateSubTitle() {
        subTitleLabel.text = NSLocalizedString("Enter your username and password", comment: "")
    }
    
    func updateTextFieldsVerticalStack() {
        textFieldsVerticalStack.removeAllArrangedSubviews()
        textFieldsVerticalStack.addArrangedSubview(resetCodeTextField)
        textFieldsVerticalStack.addArrangedSubview(newPasswordTextField)
        textFieldsVerticalStack.addArrangedSubview(confirmPasswordTextField)
        
        let height = textFieldsVerticalStack.calculateHeightBasedOn(arrangedSubviewHeight: AuthTextField.height)
        
        textFieldsVerticalStackHeightConstraint.constant = height
    }
    
    func validateInputs() -> Bool {
        let codeIsValid = resetCodeTextField.validate()
        let newPasswordIsValid = newPasswordTextField.validate()
        let passwordConfirmationIsValid = confirmPasswordTextField.validate(password: newPasswordTextField.text)
        
        let allInputsAreValid = codeIsValid && newPasswordIsValid && passwordConfirmationIsValid
        
        return allInputsAreValid
    }
    
    func navigateBackToLoginScreen() {
        navigationController?.popViewController(animated: true)
    }
}

extension PasswordResetScreenVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focusOnNextTextFieldOnPressReturn(from: textField)
        
        return false
    }
    
}
