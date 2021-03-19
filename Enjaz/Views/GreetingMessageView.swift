
import UIKit

class GreetingMessageView: UIView {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .lightGray
        label.font = label.font.withSize(16)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .accentColor
        label.font = label.font.withSize(16)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
    }
    
    func setupSubviews() {
        setupImage()
        setupWelcomeLabel()
        setupMessageLabel()
    }
    
    func setupImage() {
        addSubview(image)
        
        let size = LayoutConstants.screenWidth * 0.064
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.heightAnchor.constraint(equalToConstant: size),
            image.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupWelcomeLabel() {
        addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            welcomeLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
        ])
    }
    
    func setupMessageLabel() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 3),
            messageLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 35),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
        ])
    }
    
}
