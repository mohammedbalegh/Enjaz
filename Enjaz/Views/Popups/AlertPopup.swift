import UIKit

class AlertPopup: Popup {
    
    let imageView: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let fontSize: CGFloat = max(20, LayoutConstants.screenWidth * 0.06)
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = .invertedSystemBackground
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        
        return label
    }()
	
	var buttonLabel: [String]?
    
    override func setupSubViews() {
		super.setupSubViews()
        setupSuccessImage()
        setupTitleLabel()
        setupMessageLabel()
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
    
    func present(withImage image: UIImage?, title: String, message: String) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        present(animated: true)
    }
    
    func presentAsError(withMessage message: String) {
        let image = UIImage(named: "errorImage")
        let title = NSLocalizedString("Error", comment: "")
        present(withImage: image, title: title, message: message)
    }
    
    func presentAsInternetConnectionError() {
        presentAsError(withMessage: NSLocalizedString("No Internet Connection", comment: ""))
    }
    
}
