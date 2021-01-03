import UIKit

class ScreenNavigatorTableViewCell: UITableViewCell {
    var viewModel: ScreenNavigatorCellModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            label.text = viewModel.label
            subLabel.text = viewModel.subLabel
            iconImageView.image = viewModel.image
        }
    }
    
    let iconImageView = UIImageView(frame: .zero)
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.textColor = .black
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.font = .systemFont(ofSize: 8.5)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .lightGray
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, subLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    let arrowIcon: UIImageView = {
        let image = UIImage(systemName: "chevron.forward")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let horizontalPadding: CGFloat = 15
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure()
        setupSubViews()
    }
    
    func configure() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: frame.width * 0.025, bottom: 8, right: frame.width * 0.025))
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.borderColor.cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    func setupSubViews() {
        setupIconImageView()
        setupLabelsStack()
        setupArrowIcon()
    }
        
    func setupIconImageView() {
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
                
        iconImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
        ])
    }
    
    func setupLabelsStack() {
        contentView.addSubview(labelsStack)
                
        NSLayoutConstraint.activate([
            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            labelsStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            labelsStack.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }

    func setupArrowIcon() {
        contentView.addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            arrowIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            arrowIcon.heightAnchor.constraint(equalToConstant: 30),
            arrowIcon.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.1),
        ])
    }
}
