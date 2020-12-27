import UIKit

class AlertPopup: Popup {
    
    var imageView: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let fontSize: CGFloat = max(20, LayoutConstants.screenWidth * 0.06)
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = .black
        
        return label
    }()
    var messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        
        return label
    }()
    
    override func onPopupContainerShown() {
        setupPopupContainer()
        setupSuccessImage()
        setupTitleLabel()
        setupMessageLabel()
    }
    
    func setupPopupContainer() {
        popupContainer.backgroundColor = .white
        popupContainer.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            popupContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
        ])
    }
    
    func setupSuccessImage() {
        popupContainer.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: LayoutConstants.screenHeight * 0.021),
            imageView.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: popupContainer.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: popupContainer.widthAnchor, multiplier: 0.5),
        ])
    }
    
    func setupTitleLabel() {
        popupContainer.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConstants.screenHeight * 0.02),
            titleLabel.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: popupContainer.widthAnchor, multiplier: 0.9),
        ])
    }
    
    func setupMessageLabel() {
        popupContainer.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.018),
            messageLabel.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: popupContainer.widthAnchor, multiplier: 0.9),
        ])
    }
    
    func show(withImage image: UIImage?, title: String, message: String) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        show()
    }
    
    func showAsError(withMessage message: String) {
        let image = UIImage(named: "errorImage")
        let title = "خطأ"
        show(withImage: image, title: title, message: message)
    }
    
    func showAsInternetConnectionError() {
        showAsError(withMessage: "لا يوجد اتصال بالانترنت")
    }
}
