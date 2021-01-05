import UIKit

class SideMenuVC: UIViewController {

    lazy var dismissBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(onDismissBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.text = user?.name
        
        return label
    }()
    
    let draftBtn = SideMenuBtn(label: "المدونة", image: UIImage(named: "draftIcon"))
    let noteBtn = SideMenuBtn(label: "المفكرة", image: UIImage(named: "noteIcon"))
    let goalsRatingBtn = SideMenuBtn(label: "تقييمات أهدافي", image: UIImage(named: "starIcon"))
    let rateAppBtn = SideMenuBtn(label: "تقييم التطبيق", image: UIImage(named: "rateAppIcon"))
    let aboutAppBtn = SideMenuBtn(label: "عن التطبيق", image: UIImage(named: "infoIcon"))
    let privacyPolicyBtn = SideMenuBtn(label: "سياسة الخصوصية", image: UIImage(named: "sheetIcon"))
    let contactUsBtn = SideMenuBtn(label: "اتصل بنا", image: UIImage(named: "phoneIcon"))
    
    lazy var menuBtnsVerticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [draftBtn, noteBtn, goalsRatingBtn, rateAppBtn, aboutAppBtn, privacyPolicyBtn, contactUsBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.045
        
        return stackView
    }()
    
    let signOutBtn = SideMenuBtn(label: "تسجيل الخروج", image: UIImage(named: "signOutIcon"))
    
    var user = UserDefaultsManager.user
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.applyAccentColorGradient(size: view.frame.size, axis: .vertical)
        
        setupSubviews()
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
    
    @objc func onDismissBtnTap() {
        dismiss(animated: true)
    }
}
