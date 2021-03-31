import UIKit

class UserProfileScreenVC: UIViewController {
    
    let user = UserDefaultsManager.user
    let width = LayoutConstants.screenWidth * 0.828
    let height = LayoutConstants.screenHeight * 0.05
    
    let logoutBtn: UserProfileButtonView = {
        let button = UserProfileButtonView()
        button.button.setTitle(NSLocalizedString("Logout", comment: ""), for: .normal)
        button.btnIcon.image = UIImage(named: "logoutIcon")
        button.arrowIcon.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let medalsBtn: UserProfileButtonView = {
        let button = UserProfileButtonView()
        button.button.setTitle(NSLocalizedString("Awards and medals", comment: ""), for: .normal)
        button.btnIcon.image = UIImage(named: "medalIcon")
        button.button.addTarget(self, action: #selector(handleMedalsBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let changePasswordBtn: UserProfileButtonView = {
        let button = UserProfileButtonView()
        button.button.setTitle(NSLocalizedString("Change password", comment: ""), for: .normal)
        button.btnIcon.image = UIImage(named: "lockIcon")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        userNameLabel.text = user?.name
        
        setupSubViews()
    }
    
    func setupSubViews() {
        setupUserNameLabel()
        setupChangePasswordBtn()
        setupMedalsBtn()
        setupLogoutBtn()
    }
    
    @objc func handleMedalsBtnTapped() {
        navigationController?.pushViewController(AwardsAndMedalsScreenVC(), animated: true)
    }
    
    func setupLogoutBtn() {
        view.addSubview(logoutBtn)

        NSLayoutConstraint.activate([
            logoutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.069)),
            logoutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutBtn.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.322),
            logoutBtn.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.031)
        ])
    }
    
    func setupMedalsBtn() {
        view.addSubview(medalsBtn)

        NSLayoutConstraint.activate([
            medalsBtn.topAnchor.constraint(equalTo: changePasswordBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.037),
            medalsBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            medalsBtn.widthAnchor.constraint(equalToConstant: width),
            medalsBtn.heightAnchor.constraint(equalToConstant: height)
        ])
        
        medalsBtn.layoutIfNeeded()
        
        medalsBtn.button.addBottomBorder(withColor: .lightGray, andWidth: 0.3)
    }
    
    func setupChangePasswordBtn() {
        view.addSubview(changePasswordBtn)

        NSLayoutConstraint.activate([
            changePasswordBtn.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.164),
            changePasswordBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePasswordBtn.widthAnchor.constraint(equalToConstant: width),
            changePasswordBtn.heightAnchor.constraint(equalToConstant: height)
        ])
        
        changePasswordBtn.layoutIfNeeded()
        
        changePasswordBtn.button.addBottomBorder(withColor: .lightGray, andWidth: 0.3)
    }
    
    func setupUserNameLabel() {
        view.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.188),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.3),
            userNameLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.028)
        ])
    }
    
    
    
    
    
    
}
