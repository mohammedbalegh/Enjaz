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
        
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .highContrastText
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
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
			
			actionsRowHeightConstraint.constant = 35
		}
	}
	
	var actionsRowHeightConstraint: NSLayoutConstraint!
	var titleLabelTopAnchorConstraint: NSLayoutConstraint?
    
    override func setupSubViews() {
		super.setupSubViews()
        setupImageView()
        setupTitleLabel()
        setupMessageLabel()
		setupActionsRow()
    }
	
    func setupImageView() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        		
        NSLayoutConstraint.activate([
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
	
	func setupActionsRow() {
		contentView.addSubview(actionsRow)
		
		actionsRowHeightConstraint = actionsRow.heightAnchor.constraint(equalToConstant: 0)
		
		NSLayoutConstraint.activate([
			actionsRow.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: LayoutConstants.screenHeight * 0.018),
			actionsRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			actionsRow.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			actionsRow.widthAnchor.constraint(equalTo: contentView.widthAnchor),
			actionsRowHeightConstraint,
		])
	}
    
	func present(withImage image: UIImage? = nil, title: String, message: String?, actions: [AlertPopupAction] = []) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
		self.actions = actions
		
		adjustTitleLabelTopAnchorConstraint(image)
		
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
	
    func presentAsConfirmationAlert(title: String, message: String, confirmationBtnTitle: String, confirmationBtnStyle: AlertPopupAction.Style, confirmationHandler: @escaping () -> Void) {
		let cancelAction = AlertPopupAction(title: NSLocalizedString("Cancel", comment: ""), style: .normal) {
			self.dismiss(animated: true)
		}
		
		let signOutAction = AlertPopupAction(title: confirmationBtnTitle, style: confirmationBtnStyle, handler: confirmationHandler)
		
		present(title: title, message: message, actions: [cancelAction, signOutAction])
	}
	
	func adjustTitleLabelTopAnchorConstraint(_ image: UIImage?) {
		titleLabelTopAnchorConstraint?.isActive = false
		
		titleLabelTopAnchorConstraint = image != nil
			? titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
			: titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
		
		titleLabelTopAnchorConstraint?.isActive = true
	}
    
}
