import UIKit

class CardsView: UIView {
    
    let cardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true // Show when the cardsCount is set to a number greater than zero.
        
        return collectionView
    }()
        
    let header = CardsViewHeader()
    
    let noCardsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray2
        label.textAlignment = .center
        
        return label
    }()
    
    var noCardsMessage: String? {
        didSet {
            noCardsLabel.text = noCardsMessage
        }
    }
    
    var title: String? {
        didSet {
            header.titleLabel.text = title
        }
    }
    
    var cardsCount: Int? {
        didSet {
            guard let cardsCount = cardsCount else { return }
            
            header.cardsCount = cardsCount
            noCardsLabel.isHidden = cardsCount != 0
            cardsCollectionView.isHidden = !noCardsLabel.isHidden
            header.showAllButton.isHidden = cardsCount < 3
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupHeader()
        setupCardsCollectionView()
        setupNoCardsLabel()
    }
    
    func setupHeader() {
        addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.topAnchor),
            header.centerXAnchor.constraint(equalTo: centerXAnchor),
            header.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.88),
            header.heightAnchor.constraint(lessThanOrEqualToConstant: 22),
        ])
    }
    
    func setupCardsCollectionView() {
        addSubview(cardsCollectionView)
        
        NSLayoutConstraint.activate([
            cardsCollectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5),
            cardsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupNoCardsLabel() {
        addSubview(noCardsLabel)
        
        noCardsLabel.fill(cardsCollectionView)
    }
	
}
