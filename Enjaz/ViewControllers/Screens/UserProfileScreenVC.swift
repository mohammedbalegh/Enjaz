import UIKit
import SideMenu

class UserProfileScreenVC: UIViewController {
	
	let themePickerModels = [
		"Off".localized,
		"On".localized,
		"Auto".localized,
	]
    
    let langaugePickerModels = [
        "العربية",
        "English",
        "Auto".localized,
    ]
	
	let userNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.text = UserDefaultsManager.user?.name
		label.textColor = .lowContrastGray
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 18)
		label.minimumScaleFactor = 0.5
		label.adjustsFontSizeToFitWidth = true
		
		return label
	}()
	
    let changePasswordBtn: UserProfileButtonView = {
        let button = UserProfileButtonView()
        // Not implemented yet.
        button.isHidden = true
        button.button.setTitle("Change password".localized, for: .normal)
		button.btnIcon.image = UIImage(systemName: "lock")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
        return button
    }()
	
	let themeBtn: UserProfileButtonView = {
		let button = UserProfileButtonView()
		button.button.setTitle("Dark Mode".localized, for: .normal)
		button.btnIcon.image = UIImage(systemName: "moon")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
		button.arrowIcon.image = UIImage(systemName: "chevron.down")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
		button.button.addTarget(self, action: #selector(handleThemeBtnTap), for: .touchUpInside)
		return button
	}()
	
	let languageBtn: UserProfileButtonView = {
		let button = UserProfileButtonView()
        button.button.setTitle("Language".localized, for: .normal)
		button.btnIcon.image = UIImage(systemName: "textformat")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
		button.arrowIcon.image = UIImage(systemName: "chevron.down")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
		button.button.addTarget(self, action: #selector(handleLanguageBtnTap), for: .touchUpInside)
		return button
	}()
	
	lazy var btnsStack: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [themeBtn, languageBtn])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 30
				
		return stackView
	}()
	
	let signOutBtn: UserProfileButtonView = {
		let button = UserProfileButtonView()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.button.setTitle("Sign Out".localized, for: .normal)
		button.btnIcon.image = UIImage(named: "logoutIcon")
		button.arrowIcon.isHidden = true
		button.bottomBorder.isHidden = true
		button.button.addTarget(self, action: #selector(handleSignOutBtnTap), for: .touchUpInside)
		
		return button
	}()
	
	lazy var themePickerBottomSheet: PickerBottomSheetView = {
		let pickerBottomSheet = PickerBottomSheetView()
		
		pickerBottomSheet.picker.delegate = self
		pickerBottomSheet.picker.dataSource = self
		
		pickerBottomSheet.selectBtn.addTarget(self, action: #selector(handleThemePickerSelection), for: .touchUpInside)
		
		return pickerBottomSheet
	}()

	lazy var languagePickerBottomSheet: PickerBottomSheetView = {
		let pickerBottomSheet = PickerBottomSheetView()
		
		pickerBottomSheet.picker.delegate = self
		pickerBottomSheet.picker.dataSource = self
		
		pickerBottomSheet.selectBtn.addTarget(self, action: #selector(handleLanguagePickerSelection), for: .touchUpInside)
		
		return pickerBottomSheet
	}()
	
	var selectedThemeIndex: Int {
		return UserDefaultsManager.interfaceStyleId ?? 0
	}

	var selectedLanguageIndex: Int {
		return UserDefaultsManager.i18nLanguageId ?? 0
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
		title = "Profile".localized
        view.backgroundColor = .background
                
        setupSubViews()
    }
    
    func setupSubViews() {
        setupUserNameLabel()
        setupBtnsStack()
        setupLogoutBtn()
    }
    
	func setupUserNameLabel() {
		view.addSubview(userNameLabel)
		
		NSLayoutConstraint.activate([
			userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
			userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			userNameLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.95),
			userNameLabel.heightAnchor.constraint(equalToConstant: userNameLabel.font.pointSize + 5)
		])
	}
	    
    func setupLogoutBtn() {
        view.addSubview(signOutBtn)

        NSLayoutConstraint.activate([
            signOutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.069)),
            signOutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutBtn.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.322),
            signOutBtn.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.031)
        ])
    }
    
	func setupBtnsStack() {
		view.addSubview(btnsStack)
		
		let height = btnsStack.calculateHeightBasedOn(arrangedSubviewHeight: 50)
		
		NSLayoutConstraint.activate([
			btnsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			btnsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			btnsStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
			btnsStack.heightAnchor.constraint(equalToConstant: height),
		])
	}
	
	@objc func handleThemeBtnTap() {
		themePickerBottomSheet.picker.selectRow(selectedThemeIndex, inComponent: 0, animated: false)
		themePickerBottomSheet.present(animated: true)
	}

	@objc func handleLanguageBtnTap() {
		languagePickerBottomSheet.picker.selectRow(selectedLanguageIndex, inComponent: 0, animated: false)
		languagePickerBottomSheet.present(animated: true)
	}
		
    @objc func handleThemePickerSelection() {
        let selectedValueIndex = themePickerBottomSheet.picker.selectedRow(inComponent: 0)
        
        guard let window = UIApplication.shared.windows.first else { return }
        
        UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = InterfaceStyleConstants[selectedValueIndex] ?? .light
        }
        
        UserDefaultsManager.interfaceStyleId = selectedValueIndex
        
        themePickerBottomSheet.dismiss(animated: true)
    }
    
    @objc func handleLanguagePickerSelection() {
		let selectedValueIndex = languagePickerBottomSheet.picker.selectedRow(inComponent: 0)
				
		UserDefaultsManager.i18nLanguageId = selectedValueIndex
		
		languagePickerBottomSheet.dismiss(animated: true)
        restartApplication()
	}
	
	@objc func handleSignOutBtnTap() {
		AlertPopup().presentAsConfirmationAlert(
			title: "Are sure you want to sign out?".localized,
			message: "All data will be lost".localized,
            confirmationBtnTitle: "Sign Out".localized, confirmationBtnStyle: .destructive
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
}

extension UserProfileScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == themePickerBottomSheet.picker ? themePickerModels.count : langaugePickerModels.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == themePickerBottomSheet.picker ? themePickerModels[row] : langaugePickerModels[row]
	}
	
}


func restartApplication () {
    let rootTabBarController = RootTabBarController()
    
    let newRootViewController = UINavigationController(rootViewController: rootTabBarController)
    
    let sideMenuVC = SideMenuVC()
    let menuNavigationController = SideMenuNavigationController(rootViewController: sideMenuVC)
    SceneDelegate.layoutDirectionIsRTL = LayoutTools.getCurrentLayoutDirection(for: rootTabBarController.view) == .rightToLeft
    
    if SceneDelegate.layoutDirectionIsRTL {
        SideMenuManager.default.rightMenuNavigationController = menuNavigationController
    } else {
        SideMenuManager.default.leftMenuNavigationController = menuNavigationController
    }
    
    SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: rootTabBarController.view, forMenu: SceneDelegate.layoutDirectionIsRTL ? .right : .left)
    

    guard
        let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else { return }

    newRootViewController.view.frame = rootViewController.view.frame
    newRootViewController.view.layoutIfNeeded()

    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
        window.rootViewController = newRootViewController
    })
}
