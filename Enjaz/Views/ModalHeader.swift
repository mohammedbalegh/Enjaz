import UIKit

class ModalHeader: UIView {

    let thumb: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 25)
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("الغاء", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.accentColor, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.2
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupThumb()
        setupTitleLabel()
        setupDismissButton()
    }
    
    func setupThumb() {
        addSubview(thumb)
        
        let height: CGFloat = 5
        thumb.layer.cornerRadius = height / 2
        
        NSLayoutConstraint.activate([
            thumb.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            thumb.centerXAnchor.constraint(equalTo: centerXAnchor),
            thumb.heightAnchor.constraint(equalToConstant: height),
            thumb.widthAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: thumb.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
        ])
    }
    
    func setupDismissButton() {
        addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(lessThanOrEqualToConstant: 60),
        ])
    }
}
