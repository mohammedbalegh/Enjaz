import UIKit

class WateringTreePopup: AlertPopup {
    
    let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.borderColor = UIColor.accent.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = CGFloat(5)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Placeholder",
            attributes: [.paragraphStyle: paragraphStyle]
        )
        textField.placeholder = "why are you watering the tree?".localized
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupSubViews() {
        super.setupSubViews()
        blurOverlay.isUserInteractionEnabled = false
        setupTextfield()
    }
    
    func setupTextfield() {
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            textField.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    override func setupDismissBtn() {
        
    }
    
}
