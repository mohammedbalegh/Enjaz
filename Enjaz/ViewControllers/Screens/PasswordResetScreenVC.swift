import UIKit
import Network
import ReSwift

class PasswordResetScreenVC: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
	// MARK: Properties
	var lockImage: UIImageView = {
		var imageView = UIImageView(image: #imageLiteral(resourceName: "LockImage"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	var titleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "استرجاع كلمة المرور"
		let fontSize: CGFloat = max(23, LayoutConstants.screenHeight * 0.025)
		label.font = UIFont.systemFont(ofSize: fontSize)
		label.textColor = .accentColor
		return label
	}()
	var subTitleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.lineBreakMode = .byWordWrapping
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "من فضلك أدخل البريد الإلكتروني حتى يتم إرسال\n كود التأكيد لك ويتم تأكيد الحساب"
		let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
		label.font = UIFont.systemFont(ofSize: fontSize)
		label.textColor = .gray
		return label
	}()
	var emailTextField = EmailTextField()
	var resetCodeTextField = ResetCodeTextField()
	var newPasswordTextField = NewPasswordTextField()
	var confirmPasswordTextField = ConfirmPasswordTextField()
	lazy var textFieldsVSV: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [emailTextField])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 3
		return stackView
	}()
	lazy var nextBtn: PrimaryBtn = {
		var button = PrimaryBtn(label: "التالي", theme: .blue, size: .large)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(onNextBtnTap), for: .touchUpInside)
		return button
	}()
	lazy var backBtn: UIButton = {
		var button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("الرجوع", for: .normal)
		button.setTitleColor(.accentColor, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 20)
		button.addTarget(self, action: #selector(onBackBtnTap), for: .touchUpInside)
		return button
	}()
	lazy var controlBtnsVSV: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [nextBtn, backBtn])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 15
		
		return stackView
	}()
	lazy var resetPasswordPopup: ResetPasswordPopup = {
		let popup = ResetPasswordPopup(hideOnOverlayTap: false)
		popup.backToLoginBtn.addTarget(self, action: #selector(onPopupBackToLoginScreenBtnTap), for: .touchUpInside)
		return popup
	}()
    let alertPopup = AlertPopup(hideOnOverlayTap: true)
    
    var isConnectedToInternet = false
    
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
		setupLockImage()
		setupTitleLabel()
		setupSubTitleLabel()
		setupTextFieldsVSV()
		setupControlBtnsVSV()
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
			titleLabel.topAnchor.constraint(equalTo: lockImage.bottomAnchor)
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
			textFieldsVSV.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
			textFieldsVSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			textFieldsVSV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
			textFieldsVSV.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
		])
	}
	
	func setupControlBtnsVSV() {
		view.addSubview(controlBtnsVSV)
		controlBtnsVSV.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			controlBtnsVSV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LayoutConstants.screenHeight * 0.18),
			controlBtnsVSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			controlBtnsVSV.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
			controlBtnsVSV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
		])
	}
	
	// MARK: Event Handlers
	
	@objc func onNextBtnTap() {
        let emailIsValid = emailTextField.validate()
        
        guard emailIsValid else { return }
        
		subTitleLabel.text = "ادخل اسم المستخدم و كلمة السر"
		
		nextBtn.setTitle("ابدأ الآن", for: .normal)
		nextBtn.removeTarget(self, action: #selector(onNextBtnTap), for: .touchUpInside)
		nextBtn.addTarget(self, action: #selector(onStartBtnTap), for: .touchUpInside)

		
		textFieldsVSV.removeAllSubViews()
		textFieldsVSV.addArrangedSubview(resetCodeTextField)
		textFieldsVSV.addArrangedSubview(newPasswordTextField)
		textFieldsVSV.addArrangedSubview(confirmPasswordTextField)
        
        // TODO: Request rest password code from backend
	}
	
    // MARK: Event Handlers
    
	@objc func onStartBtnTap() {
        let allInputsAreValid = validateInputs()
        guard allInputsAreValid else { return }
        
        let resetCode = resetCodeTextField.text
        let email = emailTextField.text
        let newPassword = newPasswordTextField.text
            
        guard isConnectedToInternet else {
            alertPopup.showAsInternetConnectionError()
            return
        }
            
        Auth.resetPassword(newPassword, email, resetCode) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    self.alertPopup.showAsError(withMessage: "الكود غير صحيح")
                }
                
                self.resetPasswordPopup.show()
            }
        }
    }
        		
	@objc func onBackBtnTap() {
		navigateBackToLoginScreen()
	}
	
    @objc func onPopupBackToLoginScreenBtnTap() {
        resetPasswordPopup.hide()
        navigateBackToLoginScreen()
    }
    
    // MARK: Tools
    
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
