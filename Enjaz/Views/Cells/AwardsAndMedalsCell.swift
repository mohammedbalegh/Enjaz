import UIKit

class AwardsAndMedalsCell: UICollectionViewCell {
    
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
            if medalsViewModel?.image == "" {
                itemImage.image = UIImage(named: "medalIcon-1")
            } else {
                itemImage.image = medalsViewModel!.image.toImage()
            }
            
            itemDescription.text =  medalsViewModel?.medalDescription
        }
    }
    
    var id: Int?
    
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemDescription: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lockView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
		layer.borderColor = UIColor.border.cgColor
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupItemImage()
        setupItemLabel()
        setupItemDescription()
        setupLockView()
    }
    
    func setupItemImage() {
        addSubview(itemImage)
        
        let size = LayoutConstants.screenWidth * 0.17
        
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            itemImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemImage.widthAnchor.constraint(equalToConstant: size),
            itemImage.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupItemLabel() {
        addSubview(itemLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: 15),
            itemLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.028),
            itemLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.22)
        ])
    }
    
    func setupItemDescription() {
        addSubview(itemDescription)
        
        NSLayoutConstraint.activate([
            itemDescription.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 5),
            itemDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            itemDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            itemDescription.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupLockView() {
        addSubview(lockView)
        
        NSLayoutConstraint.activate([
            lockView.topAnchor.constraint(equalTo: topAnchor),
            lockView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lockView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lockView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		layer.borderColor = UIColor.border.cgColor
	}
}
