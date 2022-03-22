import UIKit

class ShowAllBtn: UIButton {
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Show All".localized
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    let iconImageView: UIImageView = {
        let image = UIImage(systemName: "arrow.forward.circle.fill")
        
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = .accent
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupIconImageView()
        setupLabel()
    }
    
    func setupIconImageView() {
        addSubview(iconImageView)
        
        let size: CGFloat = 18
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: size),
            iconImageView.heightAnchor.constraint(equalToConstant: size),
        ])
    }
    
    func setupLabel() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -6),
            label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor),
        ])
    }
    
}
