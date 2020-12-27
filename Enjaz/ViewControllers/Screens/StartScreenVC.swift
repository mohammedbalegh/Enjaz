
import UIKit

class StartScreenVC: UIViewController {
    
    var illustration: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "firstscreenIllustration")
        return imageView
    }()
    
    var logo: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    var startBtn = PrimaryBtn(label: "ابدأ", theme: .blue, size: .small)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    func setupSubviews() {
        setupIllustration()
        setupLogo()
        setupStartBtn()
    }
    
    func setupIllustration() {
        view.addSubview(illustration)
        let height: CGFloat = 275
        let width: CGFloat = 251
        
        NSLayoutConstraint.activate([
            illustration.topAnchor.constraint(equalTo: view.topAnchor, constant: (LayoutConstants.screenHeight * 0.1)),
            illustration.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            illustration.heightAnchor.constraint(equalToConstant: height),
            illustration.widthAnchor.constraint(equalToConstant: width),
        ])
    }
    
    func setupLogo() {
        view.addSubview(logo)
        let height: CGFloat = 131
        let width: CGFloat = 152
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: illustration.bottomAnchor, constant: 38),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: height),
            logo.widthAnchor.constraint(equalToConstant: width)
        ])
        
    }
    
    func setupStartBtn() {
        view.addSubview(startBtn)
        startBtn.addTarget(self, action: #selector(navigateToOnboardingVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            startBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.09)),
            startBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func navigateToOnboardingVC() {
        navigationController?.pushViewController(OnboardingScreenVC(), animated: true)
    }
}

