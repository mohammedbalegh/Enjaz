import UIKit

class UserProfileScreenVC: UIViewController {
	
	let themePickerModels = [
		NSLocalizedString("Off", comment: ""),
		NSLocalizedString("On", comment: ""),
		NSLocalizedString("Auto", comment: ""),
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
	
    let medalsBtn: UserProfileButtonView = {
        let button = UserProfileButtonView()
        button.button.setTitle(NSLocalizedString("Awards and medals", comment: ""), for: .normal)
        button.btnIcon.image = UIImage(named: "medalIcon")
        button.button.addTarget(self, action: #selector(handleMedalsBtnTap), for: .touchUpInside)
        return button
    }()
    
    let changePasswordBtn: UserProfileButtonView = {
        let button = UserProfileButtonView()
        button.button.setTitle(NSLocalizedString("Change password", comment: ""), for: .normal)
		button.btnIcon.image = UIImage(systemName: "lock")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
        return button
    }()
	
	let themeBtn: UserProfileButtonView = {
		let button = UserProfileButtonView()
		button.button.setTitle(NSLocalizedString("Dark Mode", comment: ""), for: .normal)
		button.btnIcon.image = UIImage(systemName: "moon")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
		button.arrowIcon.image = UIImage(systemName: "chevron.down")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
		button.button.addTarget(self, action: #selector(handleThemeBtnTap), for: .touchUpInside)
		return button
	}()
	
	lazy var btnsStack: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [medalsBtn, changePasswordBtn, themeBtn])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 30
				
		return stackView
	}()
	
	let signOutBtn: UserProfileButtonView = {
		let button = UserProfileButtonView()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.button.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)
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
	
	var selectedThemeIndex: Int {
		return UserDefaultsManager.interfaceStyleId ?? 0
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
		title = NSLocalizedString("Profile", comment: "")
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
	
	@objc func handleMedalsBtnTap() {
		let vc = AwardsAndMedalsScreenVC()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func handleThemeBtnTap() {
		themePickerBottomSheet.picker.selectRow(selectedThemeIndex, inComponent: 0, animated: false)
		themePickerBottomSheet.present(animated: true)
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
}

extension UserProfileScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return themePickerModels.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return themePickerModels[row]
	}
	
}
