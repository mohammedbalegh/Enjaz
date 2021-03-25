import UIKit

class AboutTheAppTopView: UIView {
    
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
}
