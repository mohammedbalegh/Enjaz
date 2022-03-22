import UIKit
import Network
import ReSwift

class EmailVerificationScreenVC: KeyboardHandlingViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    // MARK: Properties
    var emailImage: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "emailImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter verification code".localized
        label.font = UIFont.systemFont(ofSize: 25)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.8
        label.textColor = .accent
        return label
    }()
    
    var subTitleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Verification code sent to your email".localized
        label.font = UIFont.systemFont(ofSize: 18)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.8
        label.textColor = .gray
        return label
    }()
    
    var oneTimeCodeTextField = OneTimeCodeTextField(frame: .zero)
    
    lazy var backBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back".localized, for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleBackBtnTap), for: .touchUpInside)
        return button
    }()
    
    let alertPopup = AlertPopup()
    
    var isConnectedToInternet = false
    
    var password: String?
    
    var email: String?
    
    // MARK: Lifecycle
    
    func newState(state: AppState) {
        self.isConnectedToInternet = state.isConnectedToInternet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        store.subscribe(self)
        
        setupSubViews()
    }
    
    // MARK: SubViews Setups
    func setupSubViews() {
        setupEmailImage()
        setupTitleLabel()
        setupSubTitleLabel()
        setupOneTimeCodeTextField()
        setupBackBtn()
    }
    
    func setupEmailImage() {
        view.addSubview(emailImage)
        
        NSLayoutConstraint.activate([
            emailImage.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            emailImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            emailImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailImage.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.1)
        ])
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: emailImage.bottomAnchor)
        ])
    }
    
    func setupSubTitleLabel() {
        view.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
        ])
    }
        
    func setupOneTimeCodeTextField() {
        view.addSubview(oneTimeCodeTextField)
        oneTimeCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        oneTimeCodeTextField.configure()
        oneTimeCodeTextField.didEnterLastCharacter = handleVerificationCodeEntered
                
        NSLayoutConstraint.activate([
            oneTimeCodeTextField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.1),
            oneTimeCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oneTimeCodeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            oneTimeCodeTextField.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    func setupBackBtn() {
        view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LayoutConstants.screenHeight * 0.18),
            backBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backBtn.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            backBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleResendCodeBtnTap() {
        guard let password = password, let email = email else { return }
        
        guard isConnectedToInternet else {
            alertPopup.presentAsInternetConnectionError()
            return
        }
        
        Auth.requestEmailVerificationCode(email, password) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    self.alertPopup.presentAsError(withMessage: "The email you entered does not exist".localized)
                }
                                
                self.oneTimeCodeTextField.didEnterLastCharacter = self.handleVerificationCodeEntered
            }
        }
    }
    
    @objc func handleVerificationCodeEntered(resetCode: String) {
        guard let email = email else { return }
		
        guard isConnectedToInternet else {
            alertPopup.presentAsInternetConnectionError()
            return
        }
        
        view.isUserInteractionEnabled = false
        
        Auth.verifyEmail(email, resetCode) { (error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                
                if let error = error {
                    print(error)
                    self.alertPopup.presentAsError(withMessage: "Incorrect code".localized)
                    return
                }
            
                UserDefaultsManager.isLoggedIn = true
                self.navigateToMainTabBarController()
            }
        }
    }
    
    @objc func handleBackBtnTap() {
        navigateBackToSignupScreen()
    }
    
    // MARK: Tools
    
    func navigateBackToSignupScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToMainTabBarController() {
		dismiss(animated: true)
    }
}
