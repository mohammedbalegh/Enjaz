
import UIKit

class CardsViewHeader: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .accent
        label.font = label.font.withSize(18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        return label
    }()
    
    let cardsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
		label.textColor = .white
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
    
    var cardsCountLabelWidthConstraint: NSLayoutConstraint?
    
    var cardsCount: Int? {
        didSet {
            guard let cardsCount = cardsCount else { return }
            DispatchQueue.main.async {
                self.cardsCountLabel.text = String(cardsCount)
            }
            cardsCountLabelWidthConstraint?.constant = cardsCountLabelWidth
        }
    }
    
    let cardsCountLabelHeight: CGFloat = 15
    var cardsCountLabelWidth: CGFloat {
        let numberOfDigitsInCardsCount = String(cardsCount ?? 0).count
        return cardsCountLabelHeight + CGFloat(5 * numberOfDigitsInCardsCount - 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupTitleLabel()
        setupCardsCountLabel()
        setupShowAllButton()
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
    
    func setupCardsCountLabel() {
        addSubview(cardsCountLabel)
        cardsCountLabel.layer.cornerRadius = cardsCountLabelHeight / 2
        
        cardsCountLabelWidthConstraint = cardsCountLabel.widthAnchor.constraint(equalToConstant: cardsCountLabelWidth)
        
        NSLayoutConstraint.activate([
            cardsCountLabel.topAnchor.constraint(equalTo: self.topAnchor),
            cardsCountLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            cardsCountLabelWidthConstraint!,
            cardsCountLabel.heightAnchor.constraint(equalToConstant: cardsCountLabelHeight)
        ])
    }
    
    func setupShowAllButton() {
        addSubview(showAllButton)
        
        NSLayoutConstraint.activate([
            showAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            showAllButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            showAllButton.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            showAllButton.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.24),
        ])
    }
    
}
