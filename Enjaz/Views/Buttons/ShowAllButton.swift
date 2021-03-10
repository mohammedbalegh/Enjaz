import UIKit

class ShowAllButton: UIButton {
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("Show All", comment: "")
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    let iconImageView: UIImageView = {
        let image = UIImage(systemName: "arrow.forward.circle.fill")
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
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
