import UIKit

class DraftMetaDataContainer: UIView {

    let categoryLabel: ShimmeringLabel = {
        let label = ShimmeringLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .accent
        label.font = .systemFont(ofSize: 14.5)
        
        return label
    }()
    
    let titleLabel: ShimmeringLabel = {
        let label = ShimmeringLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14.5)
        
        return label
    }()
    
    let dateLabel: ShimmeringLabel = {
        let label = ShimmeringLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 13.5)
        
        return label
    }()
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCategoryLabel()
        setupTitleLabel()
		setupDateLabel()
    }
    
    func setupCategoryLabel() {
        addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            categoryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: categoryLabel.font.pointSize + 5),
        ])
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
			titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.pointSize + 5),
        ])
    }
	
	func setupDateLabel() {
		addSubview(dateLabel)
		
		NSLayoutConstraint.activate([
			dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
			dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			dateLabel.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.4),
			dateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: dateLabel.font.pointSize + 5),
		])
	}

}
