
import UIKit

class ItemsView: UIView {

    let cardsCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView.backgroundColor = .rootTabBarScreensBackgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true // Show when the itemsCount is set to a number greater than zero.
        
        return collectionView
    }()
    
    private let header = ItemsViewHeader()
    
    private let noItemsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "لا يوجد"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray2
        label.textAlignment = .center
        
        return label
    }()
    
    var notItemsMessage: String? {
        didSet {
            noItemsLabel.text = notItemsMessage
        }
    }
    
    var title: String? {
        didSet {
            header.titleLabel.text = title
        }
    }
    
    var itemsCount: Int? {
        didSet {
            header.itemsCount = itemsCount
            noItemsLabel.isHidden = itemsCount != 0
            cardsCollectionView.isHidden = !noItemsLabel.isHidden
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
    }
    
    func setupSubviews() {
        setupHeader()
        setupCardsCollectionView()
        setupNoItemsLabel()
    }
    
    func setupHeader() {
        addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.topAnchor),
            header.centerXAnchor.constraint(equalTo: centerXAnchor),
            header.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.88),
            header.heightAnchor.constraint(equalToConstant: 23),
        ])
    }
    
    func setupCardsCollectionView() {
        addSubview(cardsCollectionView)
        
        NSLayoutConstraint.activate([
            cardsCollectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: LayoutConstants.screenHeight * 0.02),
            cardsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupNoItemsLabel() {
        addSubview(noItemsLabel)
        
        noItemsLabel.fill(cardsCollectionView)
    }
    
}
