import UIKit

class DraftMetaDataContainer: UIView {

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .accent
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
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCategoryLabel()
        setupTitleAndDateLabelsStack()
    }
    
    func setupCategoryLabel() {
        addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            categoryLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            categoryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
        ])
    }
    
    func setupTitleAndDateLabelsStack() {
        addSubview(titleAndDateLabelsStack)
        
        NSLayoutConstraint.activate([
            titleAndDateLabelsStack.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            titleAndDateLabelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleAndDateLabelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            titleAndDateLabelsStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
        ])
    }

}
