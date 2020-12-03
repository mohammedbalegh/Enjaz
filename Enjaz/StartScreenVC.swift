
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
    
    var startBtn = PrimaryBtn(label: "ابدأ", theme: .blue)

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
        
        NSLayoutConstraint.activate([
            illustration.topAnchor.constraint(equalTo: view.topAnchor, constant: (LayoutConstants.screenHeight * 0.1)),
            illustration.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            illustration.heightAnchor.constraint(equalToConstant: (LayoutConstants.screenHeight * 0.3)),
            illustration.widthAnchor.constraint(equalToConstant: (LayoutConstants.screenWidth * 0.58)),
        ])
    }
    
    func setupLogo() {
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: illustration.bottomAnchor, constant: (LayoutConstants.screenHeight * 0.1)),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: (LayoutConstants.screenHeight * 0.14)),
            logo.widthAnchor.constraint(equalToConstant: (LayoutConstants.screenWidth * 0.36))
        ])
        
    }
    
    func setupStartBtn() {
        view.addSubview(startBtn)
        
        NSLayoutConstraint.activate([
            startBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.09)),
            startBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startBtn.heightAnchor.constraint(equalToConstant: (LayoutConstants.screenHeight * 0.06)),
            startBtn.widthAnchor.constraint(equalToConstant: (LayoutConstants.screenWidth * 0.46)),
        ])
    }
}

