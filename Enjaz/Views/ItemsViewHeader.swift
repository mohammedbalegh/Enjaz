
import UIKit

class ItemsViewHeader: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .accentColor
        label.font = label.font.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        
        return label
    }()
    
    let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.font = label.font.withSize(11)
        label.textAlignment = .center
        label.backgroundColor = UIColor(hex: 0xFF7676)
        label.clipsToBounds = true
        
        return label
    }()
    
    let showAllButton: ShowAllButton = {
        let button = ShowAllButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isHidden = true
        
        return button
    }()
    
    var itemsCountLabelWidthConstraint: NSLayoutConstraint?
    
    var itemsCount: Int? {
        didSet {
            guard let itemsCount = itemsCount else { return }
            itemsCountLabel.text = String(itemsCount)
            itemsCountLabelWidthConstraint?.constant = itemsCountLabelWidth
            showAllButton.isHidden = itemsCount < 3
        }
    }
    
    let itemsCountLabelHeight: CGFloat = 15
    var itemsCountLabelWidth: CGFloat {
        let numberOfDigitsInItemsCount = String(itemsCount ?? 0).count
        return itemsCountLabelHeight + CGFloat(5 * numberOfDigitsInItemsCount - 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
    }
    
    func setupSubviews() {
        setupTitleLabel()
        setupItemsCountLabel()
        setupShowMoreButton()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupItemsCountLabel() {
        addSubview(itemsCountLabel)
        itemsCountLabel.layer.cornerRadius = itemsCountLabelHeight / 2
        
        itemsCountLabelWidthConstraint = itemsCountLabel.widthAnchor.constraint(equalToConstant: itemsCountLabelWidth)
        
        NSLayoutConstraint.activate([
            itemsCountLabel.topAnchor.constraint(equalTo: self.topAnchor),
            itemsCountLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            itemsCountLabelWidthConstraint!,
            itemsCountLabel.heightAnchor.constraint(equalToConstant: itemsCountLabelHeight)
        ])
    }
    
    func setupShowMoreButton() {
        addSubview(showAllButton)
        
        NSLayoutConstraint.activate([
            showAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            showAllButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            showAllButton.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            showAllButton.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.24),
        ])
    }
    
}
