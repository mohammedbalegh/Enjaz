import UIKit

class ImageAndStickerPickerPopup: Popup {
	
	lazy var imageIconOrSticker: RoundBtn = {
		let button = RoundBtn(image: nil, size: LayoutConstants.screenHeight * 0.11)
		button.isUserInteractionEnabled = false
		return button
	}()
	var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textColor = UIColor(hex: 0x011942)
		
		return label
	}()
	lazy var collectionView: UICollectionView = {
		// Layout
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 15
		layout.minimumInteritemSpacing = 15
		layout.sectionHeadersPinToVisibleBounds = true
		layout.sectionInset = .init(top: 10, left: collectionViewSectionHorizontalInset, bottom: 10, right: collectionViewSectionHorizontalInset)
		let layoutItemWidth = ((self.collectionViewWidth - collectionViewSectionHorizontalInset * 2) / 3) - 15
		layout.itemSize = CGSize(width: layoutItemWidth, height: layoutItemWidth * 1.15)
		
		// Collection View
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.clipsToBounds = true
		collectionView.backgroundColor = .white
				
		collectionView.register(AdditionImageOrStickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		return collectionView
	}()
	let popupContainerWidth = LayoutConstants.screenWidth * 0.85
	let collectionViewSectionHorizontalInset: CGFloat = 10
	lazy var collectionViewWidth = popupContainerWidth * 0.7 + collectionViewSectionHorizontalInset * 2
	let reuseIdentifier = "imageAndStickerCell"
	
	let imageTitleLabel = NSLocalizedString("Select Image", comment: "")
	let stickerTitleLabel = NSLocalizedString("Select Sticker", comment: "")
	
    var imageSelectionHandler: ((_ selectedId: Int) -> Void)?
	
	// MARK: State
	var selectedImageModelIndex: Int?
	var selectedStickerModelIndex: Int?
		
	override func popupContainerDidShow() {
        configure()
		setupPopupContainer()
		setupImageIcon()
		setupTitleLabel()
		setupCollectionView()
	}
    
	// @abstract
    func configure() {
        fatalError("Subclasses need to implement the `configure()` method.")
    }
    
	func setupPopupContainer() {
		popupContainer.backgroundColor = .white
		popupContainer.layer.cornerRadius = 20
		
		NSLayoutConstraint.activate([
			popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
			popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
			popupContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
			popupContainer.widthAnchor.constraint(equalToConstant: popupContainerWidth),
		])
	}
		
	func setupImageIcon() {
		popupContainer.addSubview(imageIconOrSticker)
		
		NSLayoutConstraint.activate([
			imageIconOrSticker.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: 10),
			imageIconOrSticker.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
		])
	}
	
	func setupTitleLabel() {
		popupContainer.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: imageIconOrSticker.bottomAnchor, constant: 10),
			titleLabel.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
		])
	}
	
	func setupCollectionView() {
		popupContainer.addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
			collectionView.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
			collectionView.widthAnchor.constraint(equalToConstant: collectionViewWidth),
			collectionView.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor),
		])
	}
}
