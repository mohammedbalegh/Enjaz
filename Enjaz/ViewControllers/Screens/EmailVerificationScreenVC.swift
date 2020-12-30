import UIKit
import Network
import ReSwift

class EmailVerificationScreenVC: UIViewController, StoreSubscriber {
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
        label.text = "ادخل رمز التأكيد"
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
        label.text = "لقد أرسلنا رمز إلى البريد الإلكتروني"
        let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = .gray
        return label
    }()
    
    var oneTimeCodeTextField = OneTimeCodeTextField(frame: .zero)
    
    lazy var backBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("الرجوع", for: .normal)
        button.setTitleColor(.accentColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(onBackBtnTap), for: .touchUpInside)
        return button
    }()
    
    let alertPopup = AlertPopup(hideOnOverlayTap: true)
    
    var isConnectedToInternet = false
    
    var password: String?
    
    var email: String?
    
    // MARK: Lifecycle
    
    func newState(state: AppState) {
        self.isConnectedToInternet = state.isConnectedToInternet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        store.subscribe(self)
        
        dismissKeyboardOnTextFieldBlur()
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
                
        NSLayoutConstraint.activate([
            oneTimeCodeTextField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.1),
            oneTimeCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oneTimeCodeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            oneTimeCodeTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.inputHeight * 0.75),
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
    
    @objc func onResendCodeBtnTap() {
        guard let password = password, let email = email else { return }
        
        guard isConnectedToInternet else {
            alertPopup.showAsInternetConnectionError()
            return
        }
        
        Auth.requestEmailVerificationCode(email, password) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    self.alertPopup.showAsError(withMessage: "البريد الإلكتروني غير مسجل")
                }
                                
                self.oneTimeCodeTextField.didEnterLastCharacter = self.onVerificationCodeEntered
            }
        }
    }
    
    @objc func onVerificationCodeEntered(resetCode: String) {
        guard let email = email else { return }
        
        guard isConnectedToInternet else {
            alertPopup.showAsInternetConnectionError()
            return
        }
                    
        Auth.verifyEmail(email, resetCode) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    self.alertPopup.showAsError(withMessage: "الكود غير صحيح")
                }
            
                self.navigateToMainTabBarController()
            }
        }
    }
    
    @objc func onBackBtnTap() {
        navigateBackToSignupScreen()
    }
    
    // MARK: Tools
    
    func navigateBackToSignupScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToMainTabBarController() {
        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
}
