
import UIKit

class EditableTextViewBadge: UIView {
    
    let leftBadgeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let badgeTitle: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightBadgeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image?.withHorizontallyFlippedOrientation()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupTitle()
        setupRightIcon()
        setupLeftIcon()
    }
    
    func setupRightIcon() {
        addSubview(rightBadgeIcon)
        
        NSLayoutConstraint.activate([
            rightBadgeIcon.trailingAnchor.constraint(equalTo: badgeTitle.leadingAnchor, constant: -10),
            rightBadgeIcon.topAnchor.constraint(equalTo: self.topAnchor),
            rightBadgeIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightBadgeIcon.widthAnchor.constraint(equalTo: rightBadgeIcon.heightAnchor),
        ])
    }
    
    func setupLeftIcon() {
        addSubview(leftBadgeIcon)
        
        NSLayoutConstraint.activate([
            leftBadgeIcon.leadingAnchor.constraint(equalTo: badgeTitle.trailingAnchor, constant: 10),
            leftBadgeIcon.topAnchor.constraint(equalTo: self.topAnchor),
            leftBadgeIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftBadgeIcon.widthAnchor.constraint(equalTo: leftBadgeIcon.heightAnchor),
        ])
    }
    
    func setupTitle() {
        addSubview(badgeTitle)
        
        NSLayoutConstraint.activate([
            badgeTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            badgeTitle.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor),
            badgeTitle.topAnchor.constraint(equalTo: self.topAnchor),
            badgeTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

}
