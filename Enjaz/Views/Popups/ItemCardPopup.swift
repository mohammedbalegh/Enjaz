import UIKit

class ItemCardPopup: Popup {
    let itemWidth = LayoutConstants.screenWidth * 0.6
	let itemHeight: CGFloat = 313
    let itemCardCellReuseIdentifier = "itemCardCell"
	
    var itemModels: [ItemModel] = [] {
        didSet {
            cardsCarouselCollectionView.reloadData()
        }
    }
	
	var itemsUpdateHandler: (() -> Void)?
	
    var dailyViewDayModels: [DailyViewDayModel] = []
    
    lazy var cardsCarouselCollectionView: UICollectionView = {
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        let layout = ZoomAndSnapFlowLayout(itemSize: itemSize)
		
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: itemCardCellReuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
			    
    override func setupSubViews() {
		super.setupSubViews()
        setupCardsCarouselCollectionViewView()
    }
    
    override func setupPopupContainer() {
        popupContainer.backgroundColor = .clear
        
        let height = itemHeight * (1 + ZoomAndSnapFlowLayout.zoomFactor)
        
        NSLayoutConstraint.activate([
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            popupContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            popupContainer.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    func setupCardsCarouselCollectionViewView() {
        popupContainer.addSubview(cardsCarouselCollectionView)
        cardsCarouselCollectionView.fillSuperView()
    }
	
	func handleCheckBtnTap(item: ItemModel, isCompleted: Bool) {
		RealmManager.completeItem(item, isCompleted: isCompleted)
		itemsUpdateHandler?()
		dismiss(animated: false)
		ItemTools.showCongratsPopup(for: item)
	}
	
}

extension ItemCardPopup: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCardCellReuseIdentifier, for: indexPath) as! ItemCardCell
		let item = itemModels[indexPath.row]
        cell.viewModel = item
		cell.cardView.isMinimized = false
		cell.itemsUpdateHandler = itemsUpdateHandler
		cell.showsCheckBtn = item.type == ItemType.achievement.id ? false : true
		cell.showsDescription = true
		cell.cardView.cardBody.checkBtnHandler = handleCheckBtnTap
        return cell
    }
    
}
