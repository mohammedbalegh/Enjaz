import UIKit
import SPAlert

class ContactUsScreenVC: KeyboardHandlingViewController {
    
    let scrollView = UIScrollView()
    
    let submitBtn: PrimaryBtn = {
        let button = PrimaryBtn(label: "Send".localized, theme: .blue, size: .large)
        button.addTarget(self, action: #selector(handleSubmitBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var clientNameView: TitledInputFieldContainer = {
        let textField = InputFieldContainerTextField()
        textField.placeholder = "Full name".localized
        textField.delegate = self
        textField.tag = 0
        textField.returnKeyType = .next
        
        let containerView = TitledInputFieldContainer(input: textField, title: "Client name".localized)
        
        return containerView
    }()
    
    lazy var phoneNumberView: TitledInputFieldContainer = {
        let textField = InputFieldContainerTextField()
        textField.placeholder = "+2010 000 000 00"
        textField.keyboardType = .asciiCapableNumberPad
        textField.delegate = self
        textField.tag = 1
        textField.returnKeyType = .next
        
        let containerView = TitledInputFieldContainer(input: textField, title: "Phone number".localized)
        
        return containerView
    }()
    
    lazy var clientNameAndPhoneNumberStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [clientNameView, phoneNumberView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
                
        return stackView
    }()
    
    let messageContentView: TitledInputFieldContainer = {
        let textView = EditableTextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.placeholder = "Type your message here".localized
        textView.font = .systemFont(ofSize: 18)
        textView.tag = 2
        
        let containerView = TitledInputFieldContainer(input: textView, title: "Message content".localized)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    let contactUsImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "contactUslogo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var name: String {
        return clientNameView.input?.inputText ?? ""
    }
    
    var phoneNumber: String {
        return phoneNumberView.input?.inputText ?? ""
    }
    
    var messageContent: String {
        return messageContentView.input?.inputText ?? ""
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .background
        title = "Contact Us".localized
    }
    
    func setupSubViews() {
        setupScrollView()
        setupContactUsImage()
        setupClientNameAndPhoneNumberStack()
        setupMessageContentView()
        setupSubmitBtn()
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
            
    func setupContactUsImage() {
        scrollView.addSubview(contactUsImage)
        
        let size = LayoutConstants.screenWidth * 0.257
        
        NSLayoutConstraint.activate([
            contactUsImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contactUsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contactUsImage.heightAnchor.constraint(equalToConstant: size),
            contactUsImage.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupClientNameAndPhoneNumberStack() {
        scrollView.addSubview(clientNameAndPhoneNumberStack)
        
        let height = clientNameAndPhoneNumberStack.calculateHeightBasedOn(arrangedSubviewHeight: LayoutConstants.inputHeight + 35)
        
        NSLayoutConstraint.activate([
            clientNameAndPhoneNumberStack.topAnchor.constraint(equalTo: contactUsImage.bottomAnchor, constant: LayoutConstants.screenHeight * 0.044),
            clientNameAndPhoneNumberStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clientNameAndPhoneNumberStack.heightAnchor.constraint(equalToConstant: height),
            clientNameAndPhoneNumberStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
        
    func setupMessageContentView() {
        scrollView.addSubview(messageContentView)
        
        NSLayoutConstraint.activate([
            messageContentView.topAnchor.constraint(equalTo: phoneNumberView.bottomAnchor, constant: 15),
            messageContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageContentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            messageContentView.heightAnchor.constraint(equalToConstant: 170),
            messageContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(LayoutConstants.tabBarHeight + 20)),
        ])
    }
    
    func setupSubmitBtn() {
        view.addSubview(submitBtn)
        
        NSLayoutConstraint.activate([
            submitBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func handleSubmitBtnTapped() {
        guard phoneNumber.isPhoneNumber else {
            AlertBottomSheetView.shared.presentAsError(withMessage: "Please enter a valid phone number".localized)
            return
        }
        
        let nonProvidedRequiredFieldNames = getNonProvidedRequiredFieldNames()
        
        if let errorMessage = String.generateRequiredFieldNamesErrorMessage(requiredFieldNames: nonProvidedRequiredFieldNames) {
            AlertBottomSheetView.shared.presentAsError(withMessage: errorMessage)
            return
        }
        
        NetworkingManager.sendEmail(name: name, phoneNumber: phoneNumber, messageContent: messageContent)
        navigationController?.popViewController(animated: true)
        
        let successMessage = generateSuccessMessage()
        SPAlert.present(title: successMessage, preset: .done)
    }
    
    func getNonProvidedRequiredFieldNames() -> [String] {
        var nonProvidedRequiredFieldNames: [String] = []
        
        let nameIsProvided = !name.isEmpty
        let phoneNumberIsProvided = !phoneNumber.isEmpty
        let messageContentIsProvided = !messageContent.isEmpty
        
        if !nameIsProvided { nonProvidedRequiredFieldNames.append(clientNameView.title!) }
        if !phoneNumberIsProvided { nonProvidedRequiredFieldNames.append(phoneNumberView.title!) }
        if !messageContentIsProvided { nonProvidedRequiredFieldNames.append(messageContentView.title!) }
        
        return nonProvidedRequiredFieldNames
    }
    
    func generateSuccessMessage() -> String {
        if UserDefaultsManager.i18nLanguage == "ar" {
            return "تم الارسال بنجاح"
        }
        
        return "Message has been sent successfully"
    }
    
    
}

extension ContactUsScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focusOnNextTextFieldOnPressReturn(from: textField)
        return false
    }
}
