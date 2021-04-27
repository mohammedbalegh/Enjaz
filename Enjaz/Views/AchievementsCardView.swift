import UIKit

class AchievementsCardView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(17)
        label.textColor = .highContrastText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.numberOfLines = 1
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 0.5
        label.layer.masksToBounds = true
        label.textColor = .highContrastGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.textColor = .highContrastGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = label.font.withSize(12)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
         self.backgroundColor = .secondaryBackground
         self.layer.cornerRadius = 8
     }
    
    override func didMoveToWindow() {
        guard window != nil else { return }
        guard superview != nil else { return }
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupTitleLabel()
        setupCategoryLabel()
        setupTimeLabel()
        setupDescriptionLabel()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        guard let superview = superview as? AchievementsCell else { return }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.9),
            titleLabel.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.1),
            titleLabel.topAnchor.constraint(equalTo: superview.medalImage.bottomAnchor, constant: 20),
        ])
    }
    
    func setupCategoryLabel() {
        addSubview(categoryLabel)
        
        let width = LayoutConstants.screenWidth * 0.208
        let height = LayoutConstants.screenHeight * 0.025
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: width),
            categoryLabel.heightAnchor.constraint(equalToConstant: height)
        ])
        
        categoryLabel.layer.cornerRadius = height / 2;
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)

        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.168),
            timeLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0184),
        ])
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
                
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
}
