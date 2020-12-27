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
        label.text = "ادخل البريد الإلكتروني"
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
        label.text = "من فضلك ادخل بريدك الإلكتروني حتي يتم ارسال \nكود التأكيد لك ويتم تأكيد الحساب"
        let fontSize: CGFloat = max(18, LayoutConstants.screenHeight * 0.02)
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = .gray
        return label
    }()
    var emailTextField = EmailTextField()
    var oneTimeCodeTextField = OneTimeCodeTextField(frame: .zero)
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
        setupEmailTextField()
        setupOneTimeCodeTextField()
        setupControlBtnsVSV()
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
    
    func setupEmailTextField() {
        view.addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.1),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
        ])
        
        emailTextField.textField.text = email
        emailTextField.isUserInteractionEnabled = false
    }
    
    func setupOneTimeCodeTextField() {
        view.addSubview(oneTimeCodeTextField)
        oneTimeCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        oneTimeCodeTextField.configure()
        
        NSLayoutConstraint.activate([
            oneTimeCodeTextField.topAnchor.constraint(equalTo: emailTextField.topAnchor),
            oneTimeCodeTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
            oneTimeCodeTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            oneTimeCodeTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 0.75),
        ])
        
        oneTimeCodeTextField.isHidden = true
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
        backBtn.isHidden = true
    }
    
    // MARK: Event Handlers
    
    @objc func onNextBtnTap() {
        let emailIsValid = emailTextField.validate()
        
        guard let password = password, emailIsValid else { return }
        
        let email = emailTextField.text
        
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
                
                self.titleLabel.text = "ادخل رمز التأكيد"
                self.subTitleLabel.text = "لقد أرسلنا رمز إلى البريد الإلكتروني"
                
                self.nextBtn.setTitle("ابدأ الآن", for: .normal)
                self.nextBtn.removeTarget(self, action: #selector(self.onNextBtnTap), for: .touchUpInside)
                
                
                self.oneTimeCodeTextField.didEnterLastCharacter = self.onVerificationCodeComplete
                
                self.emailTextField.isHidden = true
                self.oneTimeCodeTextField.isHidden = false
            }
        }
    }
    
    @objc func onVerificationCodeComplete(resetCode: String) {
        let email = emailTextField.text
        
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
