import UIKit

class SideMenuVC: UIViewController {

    lazy var dismissBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleDismissBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.text = user?.name
        
        return label
    }()
    
    let draftBtn = SideMenuBtn(label: NSLocalizedString("Draft", comment: ""), image: UIImage(named: "draftIcon"))
    let noteBtn = SideMenuBtn(label: NSLocalizedString("Note", comment: ""), image: UIImage(named: "noteIcon"))
    let goalsRatingBtn = SideMenuBtn(label: NSLocalizedString("Goals Rating", comment: ""), image: UIImage(named: "starIcon"))
    let userProfileBtn = SideMenuBtn(label: NSLocalizedString("User profile", comment: ""), image: UIImage(named: "userProfileIcon"))
    let aboutAppBtn = SideMenuBtn(label: NSLocalizedString("About App", comment: ""), image: UIImage(named: "infoIcon"))
    let privacyPolicyBtn = SideMenuBtn(label: NSLocalizedString("Privacy Policy", comment: ""), image: UIImage(named: "sheetIcon"))
    let contactUsBtn = SideMenuBtn(label: NSLocalizedString("Contact Us", comment: ""), image: UIImage(named: "phoneIcon"))
    
    lazy var menuBtnsVerticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userProfileBtn,draftBtn, noteBtn, goalsRatingBtn, aboutAppBtn, privacyPolicyBtn, contactUsBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.045
        
        return stackView
    }()
    
    let signOutBtn = SideMenuBtn(label: NSLocalizedString("Sign Out", comment: ""), image: UIImage(named: "signOutIcon"))
    
    var user = UserDefaultsManager.user
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.applyAccentColorGradient(size: view.frame.size, axis: .vertical)
        
        setupSubviews()
        
        draftBtn.addTarget(self, action: #selector(handleDraftBtnTap), for: .touchUpInside)
        userProfileBtn.addTarget(self, action: #selector(handleUserProfileBtnTap), for: .touchUpInside)
    }
    
    func setupSubviews() {
        setupDismissBtn()
        setupNameLabel()
        setupMenuBtnsStack()
        setupSignOutBtn()
    }
    
    func setupDismissBtn() {
        view.addSubview(dismissBtn)
        
        let size: CGFloat = 40
        
        NSLayoutConstraint.activate([
            dismissBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.065),
            dismissBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            dismissBtn.widthAnchor.constraint(equalToConstant: size),
            dismissBtn.heightAnchor.constraint(equalToConstant: size),
        ])
    }
    
    func setupNameLabel() {
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: dismissBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.03),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.sideMenuBtnHeight),
        ])
    }
    
    func setupMenuBtnsStack() {
        view.addSubview(menuBtnsVerticalStack)
                
        NSLayoutConstraint.activate([
            menuBtnsVerticalStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
            menuBtnsVerticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            menuBtnsVerticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBtnsVerticalStack.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8),
        ])
    }
    
    func setupSignOutBtn() {
        view.addSubview(signOutBtn)
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signOutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LayoutConstants.screenHeight * 0.06),
            signOutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            signOutBtn.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            signOutBtn.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleUserProfileBtnTap() {
        navigationController?.pushViewController(UserProfileScreenVC(), animated: true)
    }
    
    @objc func handleDraftBtnTap() {
        navigationController?.pushViewController(DraftScreenVC(), animated: true)
    }
    
    @objc func handleDismissBtnTap() {
        dismiss(animated: true)
    }
}
