import UIKit

class ItemImagePickerPopup: Popup {
	let imageCellReuseIdentifier = "imageCell"
	let imageSourceReuseIdentifier = "imageSourceCell"
	
	let itemImagePickerImageSourceCellModels = [
		ItemImagePickerImageSourceCellModel(imageSource: "cameraIcon", label: "Camera".localized),
		ItemImagePickerImageSourceCellModel(imageSource: "galleryIcon", label: "Photos".localized),
	]
	
	var delegate: ItemImagePickerPopupDelegate?
	
	var imageCellModels: [String] = [] {
		didSet {
			collectionView.reloadData()
		}
	}
	
	lazy var imageIcon: RoundBtn = {
		let button = RoundBtn()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.imageView?.contentMode = .scaleAspectFill
		button.backgroundColor = .accent
		button.isUserInteractionEnabled = false
		button.setImage(UIImage(named: "imageIcon"), for: .normal)
		button.tintColor = .white
		
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
	
	let contentViewWidth = LayoutConstants.screenWidth * 0.85
	let collectionViewSectionHorizontalInset: CGFloat = 10
	lazy var collectionViewWidth = contentViewWidth * 0.7 + collectionViewSectionHorizontalInset * 2
	
	let imageTitleLabel = "Select Image".localized
	
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
    }
    
    override func setupContentView() {
		contentView.backgroundColor = .secondaryBackground
		contentView.layer.cornerRadius = 20
		
		NSLayoutConstraint.activate([
			contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
			contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
			contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
			contentView.widthAnchor.constraint(equalToConstant: contentViewWidth),
		])
	}
		
	func setupImageIcon() {
		contentView.addSubview(imageIcon)
		
		NSLayoutConstraint.activate([
			imageIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			imageIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			imageIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
			imageIcon.heightAnchor.constraint(equalTo: imageIcon.widthAnchor),
		])
	}
	
	func setupTitleLabel() {
		contentView.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: imageIcon.bottomAnchor, constant: 10),
			titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
		])
	}
	
	func setupCollectionView() {
		contentView.addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
			collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			collectionView.widthAnchor.constraint(equalToConstant: collectionViewWidth),
			collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
		
		let imageSource = imageCellModels[indexPath.row - itemImagePickerImageSourceCellModels.count]
		cell.imageSource = imageSource
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
