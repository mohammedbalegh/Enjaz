
import UIKit

class CollectionViewTopBar: UIView {
    
    var clicked = false
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.font = label.font.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tasksCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = label.font.withSize(11)
        label.textAlignment = .center
        label.layer.borderColor = UIColor(hex: 0xFF7676).cgColor
        label.layer.backgroundColor = UIColor(hex: 0xFF7676).cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let showMoreButton: ShowMoreButton = {
        let button = ShowMoreButton()
        button.label.text = "عرض الكل"
        button.image.image = #imageLiteral(resourceName: "showMoreArrow")
        button.titleLabel?.textColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupTypeLabel()
        setupTasksCountLabel()
        setupShowMoreButton()
    }
    
    func setupTypeLabel() {
        addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.17),
            typeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
    }
    
    func setupTasksCountLabel() {
        addSubview(tasksCountLabel)
        let size = LayoutConstants.screenWidth * 0.032
        
        tasksCountLabel.layer.cornerRadius = size / 2
        
        NSLayoutConstraint.activate([
            tasksCountLabel.topAnchor.constraint(equalTo: self.topAnchor),
            tasksCountLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
            tasksCountLabel.widthAnchor.constraint(equalToConstant: size),
            tasksCountLabel.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupShowMoreButton() {
        addSubview(showMoreButton)
        
        NSLayoutConstraint.activate([
            showMoreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            showMoreButton.topAnchor.constraint(equalTo: self.topAnchor),
            showMoreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            showMoreButton.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.24)
        ])
    }
    
    
    
}
