import UIKit

class SideMenuVC: UIViewController {

	var screenNavigatorCellModels: [ScreenNavigatorCellModel] = [
		ScreenNavigatorCellModel(imageSource: "lifeTreeSideIcon", label: "Life Tree".localized, subLabel: ""),
		ScreenNavigatorCellModel(imageSource: "draftIcon", label: "Draft".localized, subLabel: ""),
		ScreenNavigatorCellModel(imageSource: "noteIcon", label: "Personal Aspects".localized, subLabel: ""),
		ScreenNavigatorCellModel(imageSource: "userProfileIcon", label: "Profile".localized, subLabel: ""),
		ScreenNavigatorCellModel(imageSource: "infoIcon", label: "About App".localized, subLabel: ""),
		ScreenNavigatorCellModel(imageSource: "sheetIcon", label: "Privacy Policy".localized, subLabel: ""),
		ScreenNavigatorCellModel(imageSource: "phoneIcon", label: "Contact Us".localized, subLabel: ""),
	]
	
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
		
        return label
    }()
	
	let screenNavigatorCellReuseIdentifier = "screenNavigatorCellReuseIdentifier"
	let signOutBtnCellReuseIdentifier = "screenNavigatorCellReuseIdentifier"
	
	lazy var screenNavigatorTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		
		tableView.register(ScreenNavigatorTableViewCell.self, forCellReuseIdentifier: screenNavigatorCellReuseIdentifier)
		
		tableView.dataSource = self
		tableView.delegate = self
		
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()
	
	var scrollViewContainsTopBorder = false
	
	lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.delegate = self
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
    
    let lifeTreeBtn = SideMenuBtn(label: NSLocalizedString("Life Tree", comment: ""), image: UIImage(named: "lifeTreeSideIcon"))
    
    let draftBtn = SideMenuBtn(label: NSLocalizedString("Draft", comment: ""), image: UIImage(named: "draftIcon"))
	
    let personalAspectsBtn = SideMenuBtn(label: NSLocalizedString("Personal Aspects", comment: ""), image: UIImage(named: "noteIcon"))
	
    let userProfileBtn = SideMenuBtn(label: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "userProfileIcon"))
	
    let aboutAppBtn = SideMenuBtn(label: NSLocalizedString("About App", comment: ""), image: UIImage(named: "infoIcon"))
	
    let privacyPolicyBtn = SideMenuBtn(label: NSLocalizedString("Privacy Policy", comment: ""), image: UIImage(named: "sheetIcon"))
	
    let contactUsBtn = SideMenuBtn(label: NSLocalizedString("Contact Us", comment: ""), image: UIImage(named: "phoneIcon"))
    
    lazy var menuBtnsVerticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userProfileBtn, lifeTreeBtn, draftBtn, personalAspectsBtn, aboutAppBtn, privacyPolicyBtn, contactUsBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.045
        
        return stackView
    }()
    
    let signOutBtn = SideMenuBtn(label: NSLocalizedString("Sign Out", comment: ""), image: UIImage(named: "signOutIcon"))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
		nameLabel.text = UserDefaultsManager.user?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        view.applyAccentColorGradient(size: view.frame.size, axis: .vertical)
        
        setupSubviews()
        
        lifeTreeBtn.addTarget(self, action: #selector(handleLifeTreeBtnTap), for: .touchUpInside)
        draftBtn.addTarget(self, action: #selector(handleDraftBtnTap), for: .touchUpInside)
        personalAspectsBtn.addTarget(self, action: #selector(handlePersonalAspectsBtn), for: .touchUpInside)
        aboutAppBtn.addTarget(self, action: #selector(handleAboutAppBtnTap), for: .touchUpInside)
        privacyPolicyBtn.addTarget(self, action: #selector(handlePrivacyPolicyBtnTap), for: .touchUpInside)
        contactUsBtn.addTarget(self, action: #selector(handleContactUsBtnTap), for: .touchUpInside)
        userProfileBtn.addTarget(self, action: #selector(handleUserProfileBtnTap), for: .touchUpInside)
        signOutBtn.addTarget(self, action: #selector(handleSignOutBtnTap), for: .touchUpInside)
    }
    
    func setupSubviews() {
        setupDismissBtn()
        setupNameLabel()
		setupScrollview()
        setupMenuBtnsStack()
//		setupScreenNavigatorTableView()
		
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
	
	func setupScrollview() {
		view.addSubview(scrollView)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}
    
    func setupMenuBtnsStack() {
		scrollView.addSubview(menuBtnsVerticalStack)
		
		let height = menuBtnsVerticalStack.calculateHeightBasedOn(arrangedSubviewHeight: 35)
		
        NSLayoutConstraint.activate([
            menuBtnsVerticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 35),
            menuBtnsVerticalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            menuBtnsVerticalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            menuBtnsVerticalStack.heightAnchor.constraint(equalToConstant: height),
        ])
    }
	
	func setupScreenNavigatorTableView() {
		view.addSubview(screenNavigatorTableView)
		
		screenNavigatorTableView.backgroundColor = .clear
		screenNavigatorTableView.backgroundView?.backgroundColor = .clear
		
		NSLayoutConstraint.activate([
			screenNavigatorTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
			screenNavigatorTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
			screenNavigatorTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			screenNavigatorTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}
	    
    func setupSignOutBtn() {
        scrollView.addSubview(signOutBtn)
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
		
        NSLayoutConstraint.activate([
			signOutBtn.topAnchor.constraint(greaterThanOrEqualTo: menuBtnsVerticalStack.bottomAnchor, constant: 55),
            signOutBtn.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -LayoutConstants.screenHeight * 0.06),
            signOutBtn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50),
            signOutBtn.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor),
            signOutBtn.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handlePrivacyPolicyBtnTap() {        
        navigationController?.pushViewController(PrivacyPolicyScreenVC(), animated: true)
    }
    
    @objc func handleAboutAppBtnTap() {
        navigationController?.pushViewController(AboutAppScreenVC(), animated: true)
    }
    
    @objc func handleContactUsBtnTap() {
        navigationController?.pushViewController(ContactUsScreenVC(), animated: true)
    }
    
    @objc func handleUserProfileBtnTap() {
        navigationController?.pushViewController(UserProfileScreenVC(), animated: true)
    }
    
    @objc func handleLifeTreeBtnTap() {
        navigationController?.pushViewController(LifeTreeVC(), animated: true)
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
		AlertPopup().presentAsConfirmationAlert(
			title: NSLocalizedString("Are sure you want to sign out?", comment: ""),
			message: NSLocalizedString("All data will be lost", comment: ""),
            confirmationBtnTitle: NSLocalizedString("Sign Out", comment: ""), confirmationBtnStyle: .destructive
		) {
			Auth.signOut()
			self.navigateToLoginScreen()
		}
    }
	
	func navigateToLoginScreen() {
		let authNavigationController = UINavigationController(rootViewController: LoginScreenVC())
		authNavigationController.modalPresentationStyle = .fullScreen
		present(authNavigationController, animated: true)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		view.updateAccentColorGradient()
	}
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return screenNavigatorCellModels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = screenNavigatorTableView.dequeueReusableCell(withIdentifier: screenNavigatorCellReuseIdentifier) as! ScreenNavigatorTableViewCell
		
		cell.viewModel = screenNavigatorCellModels[indexPath.row]
		cell.arrowIcon.isHidden = true
//		cell.contentView.backgroundColor = .clear
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 62
	}
	
}

extension SideMenuVC: UIScrollViewDelegate {
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y > 10 && !scrollViewContainsTopBorder {
			UIView.animate(withDuration: 0.2) {
				scrollView.addTopBorder(withColor: .white, andWidth: 1)
			}
			scrollViewContainsTopBorder = true
		} else {
			UIView.animate(withDuration: 0.2) {
				scrollView.removeAllBorders()
			}
			scrollViewContainsTopBorder = false
		}
	}
}
