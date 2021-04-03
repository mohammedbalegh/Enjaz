import UIKit

class ContactUsScreenVC: UIViewController {
    
    let submitBtn: PrimaryBtn = {
        let button = PrimaryBtn(label: NSLocalizedString("Send", comment: ""), theme: .blue, size: .large)
        button.addTarget(self, action: #selector(handleSubmitBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let clientNameView: ContactUsTextFieldView = {
        let view = ContactUsTextFieldView()
        
        view.titleLabel.text =  NSLocalizedString("Client name", comment: "")
        view.placeholder = NSLocalizedString("Full name", comment: "")
        view.inputTextView.keyboardType = .alphabet
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let phoneNumberView: ContactUsTextFieldView = {
        let view = ContactUsTextFieldView()
        
        view.titleLabel.text =  NSLocalizedString("Phone number", comment: "")
        view.placeholder = "+2010 000 000 00"
        view.inputTextView.keyboardType = .asciiCapableNumberPad
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageContentView: ContactUsTextFieldView = {
        let view = ContactUsTextFieldView()
        
        view.placeholder = NSLocalizedString("This is message example", comment: "")
        view.titleLabel.text =  NSLocalizedString("Message content", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contactUsImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "contactUslogo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .mainScreenBackgroundColor
        title = NSLocalizedString("Contact Us", comment: "")
    }
    
    func setupSubViews() {
        setupContactUsImage()
        setupClientNameView()
        setupPhoneNumberView()
        setupMessageContentView()
        setupSubmitBtn()
    }
    
    @objc func handleSubmitBtnTapped() {
        let alertPopup = AlertPopup(hideOnOverlayTap: true)
        
        if clientNameView.inputTextView.textColor == UIColor.placeholderText || clientNameView.inputTextView.text.isEmpty {
            
            alertPopup.presentAsError(withMessage: NSLocalizedString("Name field can't be empty", comment: ""))
            
        } else if !phoneNumberView.inputTextView.text.isPhone() {
            
            alertPopup.presentAsError(withMessage: NSLocalizedString("Please enter a valid phone number", comment: ""))
            
        } else if messageContentView.inputTextView.textColor == UIColor.placeholderText || messageContentView.inputTextView.text.isEmpty {
            
            alertPopup.presentAsError(withMessage: NSLocalizedString("Message field can't be empty" , comment: ""))
            
        } else {
            NetworkingManager.sendEmail(name: clientNameView.inputTextView.text, phoneNumber: phoneNumberView.inputTextView.text, messageContent: messageContentView.inputTextView.text)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    func setupSubmitBtn() {
        view.addSubview(submitBtn)
        
        NSLayoutConstraint.activate([
            submitBtn.topAnchor.constraint(equalTo: messageContentView.bottomAnchor, constant: LayoutConstants.screenHeight * 0.038),
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
    }
    
    func setupMessageContentView() {
        view.addSubview(messageContentView)
        
        NSLayoutConstraint.activate([
            messageContentView.topAnchor.constraint(equalTo: phoneNumberView.bottomAnchor, constant: 15),
            messageContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageContentView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.209),
            messageContentView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.855)
        ])
    }
    
    func setupPhoneNumberView() {
        view.addSubview(phoneNumberView)
        
        NSLayoutConstraint.activate([
            phoneNumberView.topAnchor.constraint(equalTo: clientNameView.bottomAnchor, constant: 15),
            phoneNumberView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.1),
            phoneNumberView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.855)
        ])
    }
    
    func setupClientNameView() {
        view.addSubview(clientNameView)
        
        NSLayoutConstraint.activate([
            clientNameView.topAnchor.constraint(equalTo: contactUsImage.bottomAnchor, constant: LayoutConstants.screenHeight * 0.044),
            clientNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clientNameView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.1),
            clientNameView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.855)
        ])
    }
    
    func setupContactUsImage() {
        view.addSubview(contactUsImage)
        
        let size = LayoutConstants.screenWidth * 0.257
        
        NSLayoutConstraint.activate([
            contactUsImage.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.147),
            contactUsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contactUsImage.heightAnchor.constraint(equalToConstant: size),
            contactUsImage.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
}
