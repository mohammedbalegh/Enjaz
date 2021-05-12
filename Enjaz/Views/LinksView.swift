import UIKit

class LinksView: UIView {
    
    let topSpace = LayoutConstants.screenHeight * 0.018
    let buttonSize = LayoutConstants.screenWidth * 0.1
    
    var logoImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var twitterButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "twitterIcon-1"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return  button
    }()
    
    var facebookButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "facebookIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return  button
    }()
    
    var instagramButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "instagramIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return  button
    }()
    
    var snapChatButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "snapchatIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return  button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [twitterButton, facebookButton, instagramButton, snapChatButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
        twitterButton.addTarget(self, action: #selector(handleTwitterButtonTaped), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(handleFacebookButtonTaped), for: .touchUpInside)
        instagramButton.addTarget(self, action: #selector(handleInstagramButtonTaped), for: .touchUpInside)
        snapChatButton.addTarget(self, action: #selector(handleSnapChatButtonTaped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupLogoImage()
        setupButtonsStackView()
    }
    
    func setupLogoImage() {
        addSubview(logoImage)
        
        let width = LayoutConstants.screenWidth * 0.244
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: self.topAnchor),
            logoImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: width),
            logoImage.heightAnchor.constraint(equalToConstant: width * 0.865)
            
        ])
    }
    
    func setupButtonsStackView() {
        addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: topSpace),
            buttonsStackView.heightAnchor.constraint(equalToConstant: buttonSize),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleTwitterButtonTaped() {
        if let url = URL(string: "https://twitter.com/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func handleFacebookButtonTaped() {
        if let url = URL(string: "https://www.facebook.com/") {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    @objc func handleInstagramButtonTaped() {
        if let url = URL(string: "https://www.instagram.com/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func handleSnapChatButtonTaped() {
        if let url = URL(string: "https://www.snapchat.com/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
