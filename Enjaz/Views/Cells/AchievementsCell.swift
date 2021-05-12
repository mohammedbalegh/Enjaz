import UIKit

class AchievementsCell: UICollectionViewCell {
    
    var viewModel: ItemModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            medalImage.image = UIImage.getImageFrom(RealmManager.retrieveItemImageSourceById(viewModel.image_id) ?? "")
            achievementsCardInfo.titleLabel.text = viewModel.name
            achievementsCardInfo.categoryLabel.text = RealmManager.retrieveItemCategoryById(viewModel.category_id)?.localized_name
            let date = Date(timeIntervalSince1970: viewModel.date)
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let result = formatter.string(from: date)
            achievementsCardInfo.timeLabel.text =  result
            achievementsCardInfo.descriptionLabel.text = viewModel.item_description
        }
    }
    
    let achievementsCardInfo: AchievementsCardView = {
        let view = AchievementsCardView()
        view.timeLabel.textColor = .accent
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let medalImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let bottomRightIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "bottomRightIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let topLeftIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "topLeftIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondaryBackground
        
        layer.cornerRadius = 25
        clipsToBounds = true
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupTopLeftIcon()
        setupBottomRightIcon()
        setupMedalImage()
        setupAchievementsCardInfo()
    }
    
    func setupAchievementsCardInfo() {
        addSubview(achievementsCardInfo)
        
        
        NSLayoutConstraint.activate([
            achievementsCardInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            achievementsCardInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            achievementsCardInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            achievementsCardInfo.topAnchor.constraint(equalTo: medalImage.bottomAnchor , constant: LayoutConstants.screenHeight * 0.05)
        ])
    }
    
    func setupMedalImage() {
        addSubview(medalImage)
        
        NSLayoutConstraint.activate([
            medalImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            medalImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			medalImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            medalImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.28),
        ])
    }
    
    func setupBottomRightIcon() {
        addSubview(bottomRightIcon)
        
        NSLayoutConstraint.activate([
            bottomRightIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.screenHeight * 0.212),
            bottomRightIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstants.screenWidth * 0.046),
            bottomRightIcon.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.073),
            bottomRightIcon.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.113)
        ])
    }
    
    func setupTopLeftIcon() {
        addSubview(topLeftIcon)
        
        NSLayoutConstraint.activate([
            topLeftIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.screenHeight * 0.061),
            topLeftIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(LayoutConstants.screenWidth * 0.0515)),
            topLeftIcon.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.057),
            topLeftIcon.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.069)
        ])
    }
    
}
