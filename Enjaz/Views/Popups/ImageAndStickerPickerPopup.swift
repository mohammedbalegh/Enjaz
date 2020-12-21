import UIKit

class ImageAndStickerPickerPopup: Popup {
	
	// TODO: Refactor the popup to two different subclasses (one for each type). And pass the models from the view controller, for the fetching logic will be on run on the VC.
	
	var additionImageCellModels: [AdditionImageOrStickerCellModel] = [
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "bookImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
	]
	
	var additionStickerCellModels: [AdditionImageOrStickerCellModel] = [
		AdditionImageOrStickerCellModel(image: UIImage(named: "bookImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
		AdditionImageOrStickerCellModel(image: UIImage(named: "mosqueImage"), isSelected: false),
	]
		
	enum PopupType {
		case image, sticker
	}
	
	var popupType: PopupType = .image {
		didSet {
			titleLabel.text = popupType == .image ? imageTitleLabel : stickerTitleLabel
			let image = UIImage(named: self.popupType == .image ? "imageIcon" : "stickerIconBlue")
			imageIconOrSticker.setImage(image, for: .normal)
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
		
		label.text = "اختر صورة مناسبة"
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
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(AdditionImageOrStickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		return collectionView
	}()
	let popupContainerWidth = LayoutConstants.screenWidth * 0.85
	let collectionViewSectionHorizontalInset: CGFloat = 10
	lazy var collectionViewWidth = popupContainerWidth * 0.7 + collectionViewSectionHorizontalInset * 2
	let reuseIdentifier = "cell"
	
	let imageTitleLabel = "اختر صورة مناسبة"
	let stickerTitleLabel = "اختر الاستكير المناسب"
	
	var onImageSelected: (() -> Void)?
	
	// MARK: State
	var selectedImageModelIndex: Int?
	var selectedStickerModelIndex: Int?
		
	override func onPopupContainerShown() {
		setupPopupContainer()
		setupImageIcon()
		setupTitleLabel()
		setupCollectionView()
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


extension ImageAndStickerPickerPopup: UICollectionViewDelegate, UICollectionViewDataSource {	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = popupType == .image ? additionImageCellModels.count : additionStickerCellModels.count
		return count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AdditionImageOrStickerCell
				
		if popupType == .image {
			cell.viewModel = additionImageCellModels[indexPath.row]
		} else {
			cell.viewModel = additionStickerCellModels[indexPath.row]
		}
		
		return cell
	}
		
	func setCellSelection(at index: Int, selected: Bool) {
		if popupType == .image {
			var selectedCellModel = additionImageCellModels[index]
			selectedCellModel.isSelected = selected
			
			additionImageCellModels[index] = selectedCellModel
			if selected {
				selectedImageModelIndex = index
			}
		} else {
			var selectedCellModel = additionStickerCellModels[index]
			selectedCellModel.isSelected = selected
			
			additionStickerCellModels[index] = selectedCellModel
			if selected {
				selectedStickerModelIndex = index
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedModelIndex = popupType == .image ? selectedImageModelIndex : selectedStickerModelIndex
		
		guard indexPath.row != (selectedModelIndex ?? -1) else { return }
		
		setCellSelection(at: indexPath.row, selected: true)
		
		if let selectedModelIndex = selectedModelIndex {
			setCellSelection(at: selectedModelIndex, selected: false)
		}
		
		collectionView.reloadData()
		onImageSelected?()
	}
	
}
