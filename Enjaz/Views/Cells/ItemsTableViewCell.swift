import UIKit

class ItemsTableViewCell: UITableViewCell {
    
    var itemModel: ItemModel? {
        didSet {
            guard let itemModel = itemModel else { return }
            
            if let imageName = RealmManager.retrieveItemImageSourceById(itemModel.image_id) {
                itemImage.image = UIImage.getImageFrom(imageName)
            } else {
                itemImage.image = nil
            }
            
            let itemCategory = RealmManager.retrieveItemCategoryById(itemModel.category)
            categoryLabel.text = itemCategory?.localized_name
            
			isPinned = itemModel.is_pinned
			
            nameLabel.text = itemModel.name
            dateAndTimeLabel.attributedText = DateAndTimeTools.getDateAndTimeLabelText(itemModel)
        }
    }
	
	var isPinned = false {
		didSet {
			let targetAlpha: CGFloat = isPinned ? 1 : 0
			UIView.animate(withDuration: 0.3) {
				self.pinImageView.alpha = targetAlpha
			}
		}
	}
    
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
        label.textColor = .highContrastText
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        return label
    }()
    
	let categoryLabelContainer: RoundView = {
		let view = RoundView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.layer.borderWidth = 0.5
		view.layer.borderColor = UIColor.systemGray.cgColor
		
		return view
	}()
	
	let categoryLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textAlignment = .center
		label.font = label.font.withSize(12)
		label.numberOfLines = 0
		label.layer.masksToBounds = true
		label.textColor = .systemGray
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.65
		
		return label
	}()
    
    let dateAndTimeLabel: UILabel = {
        let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
        label.textColor = .accent
        label.font = .systemFont(ofSize: 11)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        return label
    }()
	
	let pinImageView: UIImageView = {
		let image = UIImage(systemName: "pin.fill")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
		let imageView = UIImageView(image: image)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.transform = CGAffineTransform(rotationAngle: 45)
		
		return imageView
	}()
	
    let spacing = LayoutConstants.screenWidth * 0.07
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupItemImage()
        setupNameLabel()
		setupCategoryLabelContainer()
        setupCategoryLabel()
        setupTimeLabel()
		setupPinImageView()
    }
	
	func setupItemImage() {
		addSubview(itemImage)
		
		let size = LayoutConstants.screenWidth * 0.1
		
		NSLayoutConstraint.activate([
			itemImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
			itemImage.heightAnchor.constraint(equalToConstant: size),
			itemImage.widthAnchor.constraint(equalToConstant: size),
			itemImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
	
    func setupNameLabel() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: spacing),
			nameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.font.pointSize + 8)
        ])
    }
    
	func setupCategoryLabelContainer() {
		addSubview(categoryLabelContainer)
		let height: CGFloat = categoryLabel.font.pointSize + 8
		
		NSLayoutConstraint.activate([
			categoryLabelContainer.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: spacing),
			categoryLabelContainer.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
			categoryLabelContainer.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.2),
			categoryLabelContainer.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.4),
			categoryLabelContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
		])
	}
	
	func setupCategoryLabel() {
		categoryLabelContainer.addSubview(categoryLabel)
		categoryLabel.constrainEdgesToCorrespondingEdges(of: categoryLabelContainer, top: 0, leading: 10, bottom: 0, trailing: -10)
	}
	
	func setupTimeLabel() {
		addSubview(dateAndTimeLabel)
		
		NSLayoutConstraint.activate([
			dateAndTimeLabel.centerYAnchor.constraint(equalTo: categoryLabelContainer.centerYAnchor),
			dateAndTimeLabel.leadingAnchor.constraint(equalTo: categoryLabelContainer.trailingAnchor, constant: spacing),
			dateAndTimeLabel.widthAnchor.constraint(equalToConstant: 135),
			dateAndTimeLabel.heightAnchor.constraint(equalToConstant: dateAndTimeLabel.font.pointSize + 8),
		])
	}
	
	func setupPinImageView() {
		addSubview(pinImageView)
		
		NSLayoutConstraint.activate([
			pinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			pinImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
			pinImageView.widthAnchor.constraint(equalToConstant: 15),
			pinImageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
		])
	}
	
}
