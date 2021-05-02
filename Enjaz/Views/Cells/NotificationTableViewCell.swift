import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    var itemModel: ItemModel? {
        didSet {
            guard let itemModel = itemModel else { return }
            if let imageName = RealmManager.retrieveItemImageSourceById(itemModel.image_id) {
                itemImage.image = UIImage.getImageFrom(imageName)
            } else {
                itemImage.image = nil
            }
            
            nameLabel.text = itemModel.name
            timeLabel.attributedText = DateAndTimeTools.getDateAndTimeLabelText(itemModel)
        }
    }
    
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .background
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupItemImage()
        setupItemLabel()
        setupTimeLabel()
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
    
    func setupItemLabel() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 25),
            nameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: (LayoutConstants.screenWidth * 0.23) * 0.176)
        ])
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 25),
            timeLabel.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.5),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

}
