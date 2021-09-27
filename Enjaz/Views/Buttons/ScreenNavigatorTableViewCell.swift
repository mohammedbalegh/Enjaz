import UIKit

class ScreenNavigatorTableViewCell: UITableViewCell {
    var viewModel: ScreenNavigatorCellModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            label.text = viewModel.label
            subLabel.text = viewModel.subLabel
            iconImageView.source = viewModel.imageSource
			
			if viewModel.subLabel.isEmpty && labelsVerticalStack.arrangedSubviews.count == 2 {
				labelsVerticalStack.removeArrangedSubview(subLabel)
				subLabel.removeFromSuperview()
			} else if !viewModel.subLabel.isEmpty && labelsVerticalStack.arrangedSubviews.count == 1 {
				labelsVerticalStack.addArrangedSubview(subLabel)
			}
        }
    }
    
    let iconImageView = DynamicImageView()
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.textColor = .invertedSystemBackground
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.font = .systemFont(ofSize: 8.5)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .lowContrastGray
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
        let image = UIImage(systemName: "chevron.forward")?.withTintColor(.highContrastGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let horizontalPadding: CGFloat = 15
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
//		contentView.backgroundColor = .secondaryBackground
        selectionStyle = .none
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
    
    func setupSubViews() {
        setupIconImageView()
		setupArrowIcon()
        setupLabelsStack()
    }
        
    func setupIconImageView() {
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
                
        iconImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
        ])
        
        iconImageView.layoutIfNeeded()
        
        iconImageView.layer.cornerRadius = contentView.frame.height / 1.4
        iconImageView.layer.masksToBounds = false
        iconImageView.clipsToBounds = true
    }
	
	func setupArrowIcon() {
		contentView.addSubview(arrowIcon)
		
		NSLayoutConstraint.activate([
			arrowIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			arrowIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
			arrowIcon.heightAnchor.constraint(equalToConstant: 30),
			arrowIcon.widthAnchor.constraint(equalToConstant: 14),
		])
	}
    
    func setupLabelsStack() {
        contentView.addSubview(labelsVerticalStack)
                
        NSLayoutConstraint.activate([
            labelsVerticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsVerticalStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            labelsVerticalStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
			labelsVerticalStack.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -5),
        ])
    }

}
