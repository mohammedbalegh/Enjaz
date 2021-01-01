import UIKit

class SideMenuBtn: UIButton {
    let iconImageView = UIImageView(frame: .zero)
    let label = UILabel(frame: .zero)
    
    init(label: String, image: UIImage?) {
        super.init(frame: .zero)
        
        self.label.text = label
        iconImageView.image = image
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        setupIconImageView()
        setupLabel()
    }
        
    func setupIconImageView() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
                
        iconImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
        ])
    }
    
    func setupLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            label.heightAnchor.constraint(equalTo: heightAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
        ])
    }
}
