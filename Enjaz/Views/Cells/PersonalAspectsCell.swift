import UIKit

class PersonalAspectsCell: UICollectionViewCell {
    
    var viewModel: PersonalAspectsModel? {
        didSet {
            id = viewModel!.id
            aspectBadge.source = viewModel?.badge_image_source
            aspectTitle.text = viewModel?.title
            aspectBrief.text = viewModel?.brief_or_date
            if let category = viewModel?.category.value  {
                let itemCategory = RealmManager.retrieveItemCategoryById(category)
                aspectCategory.text = itemCategory?.localized_name
            } else {
                aspectCategory.text = ""
            }
        }
    }
    
    var id: Int = 0
    
    let aspectBadge: DynamicImageView = {
        let imageView = DynamicImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let aspectTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .highContrastText
        label.font = label.font.withSize(15)
        return label
    }()
    
    let aspectBrief: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(10)
        return label
    }()
    
    let aspectCategory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accent
        label.font = label.font.withSize(10)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
        backgroundColor = .tertiaryBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupAvatar()
        setupAspectTitle()
        setupAspectBrief()
        setupAspectCategory()
    }
    
    func setupAvatar() {
        addSubview(aspectBadge)
        
        let size = LayoutConstants.screenWidth * 0.126
        
        NSLayoutConstraint.activate([
            aspectBadge.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            aspectBadge.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstants.screenWidth * 0.0551),
            aspectBadge.heightAnchor.constraint(equalToConstant: size),
            aspectBadge.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupAspectTitle() {
        addSubview(aspectTitle)
        
        NSLayoutConstraint.activate([
            aspectTitle.leadingAnchor.constraint(equalTo: aspectBadge.trailingAnchor, constant: 12),
            aspectTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            aspectTitle.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            aspectTitle.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0254)
        ])
    }
    
    func setupAspectBrief() {
        addSubview(aspectBrief)
        
        NSLayoutConstraint.activate([
            aspectBrief.leadingAnchor.constraint(equalTo: aspectBadge.trailingAnchor, constant: 15),
            aspectBrief.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            aspectBrief.topAnchor.constraint(equalTo: self.centerYAnchor),
            aspectBrief.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0254)
        ])
    }
    
    func setupAspectCategory() {
        addSubview(aspectCategory)
        
        NSLayoutConstraint.activate([
            aspectCategory.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            aspectCategory.topAnchor.constraint(equalTo: self.centerYAnchor),
            aspectCategory.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0254),
            aspectCategory.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.078)
        ])
    }
    
}
