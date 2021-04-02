import UIKit

class AwardsAndsMedalsCell: UICollectionViewCell {
    
    var itemCategoryViewModel: ItemCategoryModel? {
        didSet {
            itemLabel.text = itemCategoryViewModel?.name
            itemImage.image = UIImage(named: (itemCategoryViewModel!.image_source))
            id = itemCategoryViewModel?.id
        }
    }

    var medalsViewModel: MedalModel? {
        didSet {
            itemLabel.text = medalsViewModel?.name
            itemImage.image = UIImage(named: medalsViewModel!.image_source)
        }
    }
    
    var id: Int?
    
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
        layer.borderColor = UIColor(hex: 0xCECECE).cgColor
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupItemImage()
        setupItemLabel()
    }
    
    func setupItemLabel() {
        addSubview(itemLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: LayoutConstants.screenHeight * 0.0125),
            itemLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.028),
            itemLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.22)
        ])
    }
    
    func setupItemImage() {
        addSubview(itemImage)
        
        let size = LayoutConstants.screenWidth * 0.17
        
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.screenHeight * 0.033),
            itemImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemImage.widthAnchor.constraint(equalToConstant: size),
            itemImage.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
}
