import UIKit

class DraftCardCell: UICollectionViewCell {
    let borderRadius: CGFloat = 18
        
    lazy var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.roundCorners([.bottomLeading, .bottomTrailing], withRadius: borderRadius)
        
        return imageView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .accentColor
        label.font = .systemFont(ofSize: 14.5)
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14.5)
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 13.5)
        
        return label
    }()
    
    lazy var titleAndDateLabelsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = borderRadius
        applyLightShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupThumbnail()
        setupCategoryLabel()
        setupTitleAndDateLabelsStack()
    }
    
    func setupThumbnail() {
        contentView.addSubview(thumbnail)
        
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnail.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.45),
        ])
    }
    
    func setupCategoryLabel() {
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            categoryLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
            categoryLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    func setupTitleAndDateLabelsStack() {
        contentView.addSubview(titleAndDateLabelsStack)
        
        NSLayoutConstraint.activate([
            titleAndDateLabelsStack.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            titleAndDateLabelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleAndDateLabelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            titleAndDateLabelsStack.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
        ])
    }
    
}
