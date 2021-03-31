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
    let personalAspectsBtn = SideMenuBtn(label: NSLocalizedString("Personal Aspects", comment: ""), image: UIImage(named: "noteIcon"))
    let userProfileBtn = SideMenuBtn(label: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "userProfileIcon"))
    let aboutAppBtn = SideMenuBtn(label: NSLocalizedString("About App", comment: ""), image: UIImage(named: "infoIcon"))
    let privacyPolicyBtn = SideMenuBtn(label: NSLocalizedString("Privacy Policy", comment: ""), image: UIImage(named: "sheetIcon"))
    let contactUsBtn = SideMenuBtn(label: NSLocalizedString("Contact Us", comment: ""), image: UIImage(named: "phoneIcon"))
    
    lazy var menuBtnsVerticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userProfileBtn, draftBtn, personalAspectsBtn, aboutAppBtn, privacyPolicyBtn, contactUsBtn])
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
        personalAspectsBtn.addTarget(self, action: #selector(handlePersonalAspectsBtn), for: .touchUpInside)
        aboutAppBtn.addTarget(self, action: #selector(handleAboutAppBtnTapped), for: .touchUpInside)
        privacyPolicyBtn.addTarget(self, action: #selector(handlePrivacyPolicyBtn), for: .touchUpInside)
        contactUsBtn.addTarget(self, action: #selector(handleContactUsBtnTap), for: .touchUpInside)
        userProfileBtn.addTarget(self, action: #selector(handleUserProfileBtnTap), for: .touchUpInside)
        signOutBtn.addTarget(self, action: #selector(handleSignOutBtnTap), for: .touchUpInside)
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
    
    @objc func handlePrivacyPolicyBtn() {
        let vc = PrivacyPolicyAndAboutAppScreenVC()
        vc.showAboutAppTopView = false
        vc.TextView.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit \", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham Where can I get some? There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleAboutAppBtnTapped() {
        let vc = PrivacyPolicyAndAboutAppScreenVC()
        vc.showAboutAppTopView = true
        vc.TextView.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit \", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham Where can I get some? There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleContactUsBtnTap() {
        navigationController?.pushViewController(ContactUsScreenVC(), animated: true)
    }
    
    @objc func handleUserProfileBtnTap() {
        navigationController?.pushViewController(UserProfileScreenVC(), animated: true)
    }
    
    @objc func handleDraftBtnTap() {
        navigationController?.pushViewController(DraftScreenVC(), animated: true)
    }
    
    @objc func handlePersonalAspectsBtn() {
        navigationController?.pushViewController(PersonalAspectsScreenVC(), animated: true)
    }
    
    @objc func handleDismissBtnTap() {
        dismiss(animated: true)
    }
    
    @objc func handleSignOutBtnTap() {
        Auth.signOut()
        UserDefaultsManager.user = nil
        UserDefaultsManager.isLoggedIn = false
        navigationController?.pushViewController(LoginScreenVC(), animated: true)
    }
}
