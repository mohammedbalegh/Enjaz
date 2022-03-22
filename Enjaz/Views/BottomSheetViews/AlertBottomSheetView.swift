import UIKit

class AlertBottomSheetView: BottomSheetView {
    static let shared = AlertBottomSheetView()
    
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
    
    lazy var dismissBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Ok".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImageView()
        setupTitleLabel()
        setupMessageLabel()
        setupDismissBtn()
    }
        
    func setupImageView() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: height * 0.1),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConstants.screenHeight * 0.02),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    func setupMessageLabel() {
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.018),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    func setupDismissBtn() {
        contentView.addSubview(dismissBtn)
        
        NSLayoutConstraint.activate([
            dismissBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(height * 0.1 + 100)),
            dismissBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dismissBtn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            dismissBtn.heightAnchor.constraint(equalToConstant: 38),
        ])
    }
    
    // MARK: Tools
    
    func present(withImage image: UIImage?, title: String, message: String) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        present(animated: true)
    }
    
    func presentAsError(withMessage message: String) {
        let image = UIImage(named: "errorImage")
        let title = "Error".localized
        present(withImage: image, title: title, message: message)
    }
    
    func presentAsInternetConnectionError() {
        presentAsError(withMessage: "No Internet Connection".localized)
    }
    
    override func dismiss(animated: Bool, withDuration duration: TimeInterval = 0.3) {
        super.dismiss(animated: animated, withDuration: duration)
        imageView.image = nil
        titleLabel.text = nil
        messageLabel.text = nil
    }
}
