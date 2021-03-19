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
    
    lazy var labelsVerticalStack: UIStackView = {
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
        backgroundColor = .white
        selectionStyle = .none
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
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
        contentView.addSubview(labelsVerticalStack)
                
        NSLayoutConstraint.activate([
            labelsVerticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsVerticalStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            labelsVerticalStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            labelsVerticalStack.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
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
