import UIKit

class ItemsTableViewCell: UITableViewCell {
    
    var itemModel: ItemModel? {
        didSet {
            guard let itemModel = itemModel else { return }
            let checkBtnColor: UIColor = itemModel.is_completed ? .accent : .systemGray
            checkBtn.setTitleColor(checkBtnColor, for: .normal)
            checkBtn.layer.borderColor = checkBtnColor.cgColor
            if let imageName = RealmManager.retrieveItemImageSourceById(itemModel.image_id) {
                itemImage.image = UIImage.getImageFrom(imageName)
            } else {
                itemImage.image = nil
            }
            
            let itemCategory = RealmManager.retrieveItemCategoryById(itemModel.category)
            categoryLabel.text = itemCategory?.localized_name
            
            nameLabel.text = itemModel.name
            timeLabel.attributedText = DateAndTimeTools.setDateAndTimeLabelText(itemModel)
            
        }
    }
    
    var checkBtnHandler: ((_ item: ItemModel, _ itemIsCompleted: Bool) -> Void)?
    
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .highContrastText
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.numberOfLines = 1
        label.layer.borderColor = UIColor.systemGray.cgColor
        label.layer.borderWidth = 0.5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("✓", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(16)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.addTarget(self, action: #selector(handleCheckBtnTap), for: .touchUpInside)
        
        return button
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
        setupItemLabel()
        setupCategoryLabel()
        setupTimeLabel()
        setupCheckBtn()
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: spacing),
            timeLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.3),
            timeLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    func setupCategoryLabel() {
        addSubview(categoryLabel)
        
        let height: CGFloat = categoryLabel.font.pointSize + 8
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: spacing),
            categoryLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
            categoryLabel.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.2),
            categoryLabel.heightAnchor.constraint(equalToConstant: height)
        ])
        
        categoryLabel.layer.cornerRadius = height / 2
    }
    
    func setupItemLabel() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: spacing),
            nameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
            nameLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.23),
            nameLabel.heightAnchor.constraint(equalToConstant: (LayoutConstants.screenWidth * 0.23) * 0.176)
        ])
    }
    
    func setupItemImage() {
        addSubview(itemImage)
        
        let size = LayoutConstants.screenWidth * 0.1
        
        NSLayoutConstraint.activate([
            itemImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstants.screenHeight * 0.03),
            itemImage.heightAnchor.constraint(equalToConstant: size),
            itemImage.widthAnchor.constraint(equalToConstant: size),
            itemImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setupCheckBtn() {
        addSubview(checkBtn)
        
        NSLayoutConstraint.activate([
            checkBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(LayoutConstants.screenWidth * 0.027)),
            checkBtn.widthAnchor.constraint(equalToConstant: 28),
            checkBtn.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        checkBtn.layer.cornerRadius = 28 / 2
    }
    
    @objc func handleCheckBtnTap() {
        guard let item = itemModel else { return }
        let updatedItemIsCompletedValue = !item.is_completed
        checkBtnHandler?(item, updatedItemIsCompletedValue)
    }

}
