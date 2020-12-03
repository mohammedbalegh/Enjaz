import UIKit

class SignUpVC: UIViewController {

    // MARK: Properties
	var appLogo = AppLogo(frame: .zero)
	var titleLabel: UILabel = {
		var label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "إنشاء حساب"
		label.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
		
		label.textColor = .accentColor
		return label
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
		setupSubViews()
    }
	
	func setupSubViews() {
		setupAppLogo()
		setupTitleLabel()
	}
	
	func setupAppLogo() {
		appLogo.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(appLogo)
		
		appLogo.contentMode = .scaleAspectFit
		NSLayoutConstraint.activate([
			appLogo.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth),
			appLogo.heightAnchor.constraint(equalToConstant: 100),
			appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			appLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.1)
		])
	}
	
	func setupTitleLabel() {
		view.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: 30)
		])
	}

}
