import UIKit
import ReSwift

class AuthScreenVC: KeyboardHandlingViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    
    // MARK: Properties
    
    let scrollView = UIScrollView()
    
    var appLogo = AppLogo(frame: .zero)
    
    let titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 25)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.8
        label.textColor = .accent
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 18)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.8
        label.textColor = .gray
        
        return label
    }()
    
    let nameTextField = NameTextField()
    let usernameTextField = UsernameTextField()
    let emailTextField = EmailTextField()
    let passwordTextField = PasswordTextField()
    let confirmPasswordTextField = ConfirmPasswordTextField()
    
    var authenticationBtn = PrimaryBtn(theme: .blue, size: .large)
    
    lazy var textFieldsVerticalStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: getTextFieldsStackArrangedSubviews())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        return stackView
    }()
    
    let otherAuthMethodLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    let otherAuthMethodBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.accent, for: .normal)
        button.addTarget(self, action: #selector(handleOtherAuthMethodBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    lazy var otherAuthMethodLabelAndBtnHorizontalStack : UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [otherAuthMethodLabel, otherAuthMethodBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
        
    let oAuthBtnsHorizontalStack = OAuthBtnsHorizontalStack()
    
    let alertPopup = AlertPopup()
    
    var authenticationBtnTopAnchorConstraint: NSLayoutConstraint!
    
    var isConnectedToInternet = false
    
    func newState(state: AppState) {
        self.isConnectedToInternet = state.isConnectedToInternet
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        store.subscribe(self)
        
        scrollView.keyboardDismissMode = .interactive
        
        configureTextFields()
        setupSubViews()
    }
        
    // MARK: SubViews Setups
    
    func setupSubViews() {
        setupScrollView()
        setupAppLogo()
        setupTitleLabel()
        setupSubTitleLabel()
        setupTextFieldsVerticalStack()
        setupAuthenticationBtn()
        setupOtherAuthMethodLabelAndBtnHorizontalStack()
        setupOAuthBtnsHorizontalStack()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: keyboardPlaceHolderView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
        ])
    }
    
    func setupAppLogo() {
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(appLogo)
        
        appLogo.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            appLogo.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor),
            appLogo.heightAnchor.constraint(equalToConstant: 85),
            appLogo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            appLogo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 4)
        ])
    }
    
    func setupTitleLabel() {
        scrollView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: LayoutConstants.screenHeight * 0.065)
        ])
    }
    
    func setupSubTitleLabel() {
        scrollView.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
    }
    
    func setupTextFieldsVerticalStack() {
        scrollView.addSubview(textFieldsVerticalStack)
        
        let height = textFieldsVerticalStack.calculateHeightBasedOn(arrangedSubviewHeight: AuthTextField.height)
        
        NSLayoutConstraint.activate([
            textFieldsVerticalStack.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
            textFieldsVerticalStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            textFieldsVerticalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            textFieldsVerticalStack.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    func setupAuthenticationBtn() {
        scrollView.addSubview(authenticationBtn)
        authenticationBtn.translatesAutoresizingMaskIntoConstraints = false
        
        authenticationBtnTopAnchorConstraint = authenticationBtn.topAnchor.constraint(equalTo: textFieldsVerticalStack.bottomAnchor, constant: LayoutConstants.screenHeight * 0.025)
        
        NSLayoutConstraint.activate([
            authenticationBtnTopAnchorConstraint,
            authenticationBtn.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        authenticationBtn.addTarget(self, action: #selector(handleAuthenticationBtnTap), for: .touchUpInside)
    }
    
    func setupOtherAuthMethodLabelAndBtnHorizontalStack() {
        scrollView.addSubview(otherAuthMethodLabelAndBtnHorizontalStack)
        
        NSLayoutConstraint.activate([
            otherAuthMethodLabelAndBtnHorizontalStack.topAnchor.constraint(equalTo: authenticationBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.0275),
            otherAuthMethodLabelAndBtnHorizontalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -LayoutConstants.screenHeight * 0.1),
            otherAuthMethodLabelAndBtnHorizontalStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            otherAuthMethodLabelAndBtnHorizontalStack.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor),
            otherAuthMethodLabelAndBtnHorizontalStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 17),
        ])
    }
    
    func setupOAuthBtnsHorizontalStack() {
        view.addSubview(oAuthBtnsHorizontalStack)
        oAuthBtnsHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let arrangedSubviewSize: CGFloat = 45
        
        let width = oAuthBtnsHorizontalStack.calculateWidthBasedOn(arrangedSubviewWidth: arrangedSubviewSize)
        
        NSLayoutConstraint.activate([
            oAuthBtnsHorizontalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            oAuthBtnsHorizontalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oAuthBtnsHorizontalStack.widthAnchor.constraint(equalToConstant: width),
            oAuthBtnsHorizontalStack.heightAnchor.constraint(equalToConstant: arrangedSubviewSize),
        ])
    }
    
    // MARK: Event Handlers
    
    // @abstract
    @objc func handleAuthenticationBtnTap() {
        fatalError("Subclasses need to implement the `handleAuthenticationBtnTap()` method.")
    }
    
    // @abstract
    @objc func handleOtherAuthMethodBtnTap() {
        fatalError("Subclasses need to implement the `handleOtherAuthMethodBtnTap()` method.")
    }
    
    // MARK: Tools
    
    // @abstract
    func getTextFieldsStackArrangedSubviews() -> [UIView] {
        fatalError("Subclasses need to implement the `getTextFieldsStackArrangedSubviews()` method.")
    }
    
    func configureTextFields() {
        var arrangedSubviewIndex = 0
        textFieldsVerticalStack.arrangedSubviews.forEach { arrangedSubview in
            guard let authTextField = arrangedSubview as? AuthTextField else { return }
            
            authTextField.textField.delegate = self
            authTextField.textField.tag = arrangedSubviewIndex
            
            let isLastTextField = arrangedSubviewIndex == textFieldsVerticalStack.arrangedSubviews.count - 1
            authTextField.textField.returnKeyType = isLastTextField ? .continue :  .next
            
            arrangedSubviewIndex += 1
        }
    }
    
    func validateInputs() -> Bool {
        var allInputsAreValid = true
        
        textFieldsVerticalStack.arrangedSubviews.forEach { arrangedSubview in
            guard let authTextField = arrangedSubview as? AuthTextField else { return }
            
            var textFieldInputIsValid = false
            
            if let authTextField = authTextField as? ConfirmPasswordTextField {
                textFieldInputIsValid = authTextField.validate(password: passwordTextField.text)
            } else {
                textFieldInputIsValid = authTextField.validate()
            }
            
            allInputsAreValid = allInputsAreValid && textFieldInputIsValid
        }
                
        return allInputsAreValid
    }
    
}

extension AuthScreenVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focusOnNextTextFieldOnPressReturn(from: textField)
        
        return false
    }
    
}
