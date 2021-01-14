
import UIKit

class MajorGoalsCell: UICollectionViewCell {
    
    var viewModel: MajorGoalsModel? {
        didSet {
            badge.rightBadgeIcon.image = UIImage(named: viewModel!.image)
            badge.leftBadgeIcon.image = UIImage(named: viewModel!.image)
            badge.badgeTitle.text = viewModel?.title
            majorDescription.text = viewModel?.description
        }
    }
    
    let badge: EditableTextViewBadge = {
        let badge = EditableTextViewBadge()
        badge.translatesAutoresizingMaskIntoConstraints = false
        return badge
    }()
    
    let majorDescription: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: EditableTextView = {
        let textField = EditableTextView(frame: .zero)
        textField.placeholder = "أكتب ما تريد تحقيقه من اهداف هنا"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupBadge()
        setupMajorDescription()
        setupTextField()
    }
        
    func setupBadge() {
        addSubview(badge)
        
        NSLayoutConstraint.activate([
            badge.topAnchor.constraint(equalTo: self.topAnchor),
            badge.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            badge.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            badge.heightAnchor.constraint(equalToConstant: 16)
        ])
        
    }
    
    func setupMajorDescription() {
        addSubview(majorDescription)
        
        NSLayoutConstraint.activate([
            majorDescription.topAnchor.constraint(equalTo: badge.bottomAnchor, constant: 5),
            majorDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            majorDescription.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor),
            majorDescription.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    func setupTextField() {
        addSubview(textField)
        
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: majorDescription.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                        textField.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.24),
        ])
    }
    
}
