
import UIKit

class WelcomeBadgeView: UIView {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupImage()
        setupWelcomeLabel()
        setupMessageLabel()
    }
    
    func setupMessageLabel() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 3),
            messageLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.023),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupWelcomeLabel() {
        addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            welcomeLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.023),
            welcomeLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor)
        ])
    }
    
    func setupImage() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.heightAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.064),
            image.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.064)
        ])
    }
}
