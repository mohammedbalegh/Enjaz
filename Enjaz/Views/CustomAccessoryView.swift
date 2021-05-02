import UIKit

class CustomAccessoryView: UIView {
    
    let cancelBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        button.setTitleColor(.accent, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGray5.withAlphaComponent(0.6)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCancelBtn()
    }
    
    func setupCancelBtn() {
        addSubview(cancelBtn)
        
        NSLayoutConstraint.activate([
            cancelBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            cancelBtn.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            cancelBtn.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
        ])
    }
    
}
