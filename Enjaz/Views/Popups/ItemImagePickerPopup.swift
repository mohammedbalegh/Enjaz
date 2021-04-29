import UIKit

class ItemImagePickerPopup: Popup {
	let imageCellReuseIdentifier = "imageCell"
	let imageSourceReuseIdentifier = "imageSourceCell"
	
	let itemImagePickerImageSourceCellModels = [
		ItemImagePickerImageSourceCellModel(imageSource: "cameraIcon", label: NSLocalizedString("Camera", comment: "")),
		ItemImagePickerImageSourceCellModel(imageSource: "galleryIcon", label: NSLocalizedString("Photos", comment: "")),
	]
	
	var delegate: ItemImagePickerPopupDelegate?
	
	var imageCellModels: [String] = [] {
		didSet {
			collectionView.reloadData()
		}
	}
	
	lazy var imageIconOrSticker: RoundBtn = {
		let button = RoundBtn(image: nil, size: LayoutConstants.screenHeight * 0.11)
		button.isUserInteractionEnabled = false
		return button
	}()
	
	var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textColor = .highContrastText
		
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
		collectionView.backgroundColor = .secondaryBackground

		collectionView.register(ItemImagePickerImageSourceCell.self, forCellWithReuseIdentifier: imageSourceReuseIdentifier)
		collectionView.register(ItemImageCell.self, forCellWithReuseIdentifier: imageCellReuseIdentifier)
		
		return collectionView
	}()
	
	let popupContainerWidth = LayoutConstants.screenWidth * 0.85
	let collectionViewSectionHorizontalInset: CGFloat = 10
	lazy var collectionViewWidth = popupContainerWidth * 0.7 + collectionViewSectionHorizontalInset * 2
	
	let imageTitleLabel = NSLocalizedString("Select Image", comment: "")
		
	// MARK: State
	var selectedImageModelIndex: Int?
	
	override func setupSubViews() {
		super.setupSubViews()
        configure()
		setupImageIcon()
		setupTitleLabel()
		setupCollectionView()
	}
    
    func configure() {
		titleLabel.text = imageTitleLabel
		collectionView.delegate = self
		collectionView.dataSource = self
		titleLabel.text = imageTitleLabel
		imageIconOrSticker.setImage(UIImage(named: "imageIcon"), for: .normal)
    }
    
    override func setupPopupContainer() {
		popupContainer.backgroundColor = .secondaryBackground
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

extension ItemImagePickerPopup: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return itemImagePickerImageSourceCellModels.count + imageCellModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellBackgroundColor = UIColor(hex: 0xF7F7F7) | UIColor(hex: 0xF7F7F7).inverted
		
		if indexPath.row < itemImagePickerImageSourceCellModels.count {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageSourceReuseIdentifier, for: indexPath) as! ItemImagePickerImageSourceCell
			
			cell.viewModel = itemImagePickerImageSourceCellModels[indexPath.row]
			cell.backgroundColor = cellBackgroundColor
			
			return cell
		}
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellReuseIdentifier, for: indexPath) as! ItemImageCell
		
		let imageName = imageCellModels[indexPath.row - itemImagePickerImageSourceCellModels.count]
		cell.image = UIImage(named: imageName)
		cell.backgroundColor = cellBackgroundColor
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row < itemImagePickerImageSourceCellModels.count {
			delegate?.ImagePickerPopup(self, didSelectImageSource: indexPath.row == 0 ? .camera : .photoLibrary)
			return
		}
		
		delegate?.ImagePickerPopup(self, didSelectImage: indexPath.row - itemImagePickerImageSourceCellModels.count)
	}
	
}
