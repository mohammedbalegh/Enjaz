
import UIKit

class TasksView: UIView {

    let cards: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal		
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        cv.backgroundColor = .rootTabBarScreensBackgroundColor
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var collectionTopBar: CollectionViewTopBar = {
        let bar = CollectionViewTopBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCollectionTopBar()
        setupCard()
    }
    
    func setupCard() {
        addSubview(cards)
        
        NSLayoutConstraint.activate([
            cards.topAnchor.constraint(equalTo: collectionTopBar.bottomAnchor, constant: LayoutConstants.screenHeight * 0.02),
            cards.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cards.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cards.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupCollectionTopBar() {
        addSubview(collectionTopBar)
        let width = LayoutConstants.screenWidth * 0.88
        let height =  width * 0.03
        
        NSLayoutConstraint.activate([
            collectionTopBar.topAnchor.constraint(equalTo: self.topAnchor),
            collectionTopBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            collectionTopBar.widthAnchor.constraint(equalToConstant: width),
            collectionTopBar.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
