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
        
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = .invertedSystemBackground
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        
        return label
    }()
	
	var actionsRow: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.alignment = .center
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	var actions: [AlertPopupAction] = [] {
		didSet {
			actionsRow.removeAllArrangedSubviews()
			
			guard !actions.isEmpty else {
				actionsRowHeightConstraint.constant = 0
				return
			}
			
			for (index, action) in actions.enumerated() {
				action.isLastAction = index == actions.count - 1
				actionsRow.addArrangedSubview(action)
			}
			
			actionsRowHeightConstraint.constant = 45
		}
	}
	
	var actionsRowHeightConstraint: NSLayoutConstraint!
    
    override func setupSubViews() {
		super.setupSubViews()
        setupSuccessImage()
        setupTitleLabel()
        setupMessageLabel()
		setupActionsRow()
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
	
	func setupActionsRow() {
		popupContainer.addSubview(actionsRow)
		
		actionsRowHeightConstraint = actionsRow.heightAnchor.constraint(equalToConstant: 0)
		
		NSLayoutConstraint.activate([
			actionsRow.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.018),
			actionsRow.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor),
			actionsRow.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
			actionsRow.widthAnchor.constraint(equalTo: popupContainer.widthAnchor),
			actionsRowHeightConstraint,
		])
	}
    
	func present(withImage image: UIImage?, title: String, message: String, actions: [AlertPopupAction] = []) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
		self.actions = actions
        present(animated: true)
    }
    
    func presentAsError(withMessage message: String, actions: [AlertPopupAction] = []) {
        let image = UIImage(named: "errorImage")
        let title = NSLocalizedString("Error", comment: "")
		present(withImage: image, title: title, message: message, actions: actions)
    }
    
    func presentAsInternetConnectionError() {
        presentAsError(withMessage: NSLocalizedString("No Internet Connection", comment: ""))
    }
    
}
