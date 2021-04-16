import UIKit

class WeekDayCell: UICollectionViewCell {
    var viewModel: WeekDayCellModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            hourLabel.text = viewModel.hourLabel
                firstItemImageView.image = viewModel.includesItems
                    ? UIImage.getImageFrom(RealmManager.retrieveItemImageSourceById(viewModel.includedItems[0].image_id) ?? "")
                    : nil
            imageViewContainer.isHidden = !viewModel.includesItems
            otherIncludedItemsLabel.isHidden = !(viewModel.includedItems.count > 1)
            otherIncludedItemsLabel.text = "+\(viewModel.includedItems.count - 1)"
        }
    }
    
    lazy var containerView: UIView = {
        let currentLayoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
        let leftInset: CGFloat = currentLayoutDirection == .rightToLeft ? 1 : 0
        let rightInset: CGFloat = 1 - leftInset
        
        let view = UIView(frame: contentView.frame.inset(by: UIEdgeInsets(top: 1, left: leftInset, bottom: 0, right: rightInset)))
        view.backgroundColor = .white
        
        return view
    }()
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 8.5)
        label.textColor = .systemGray
        return label
    }()
        
    let imageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .accentColor
        view.isHidden = true
        view.clipsToBounds = true
        
        return view
    }()
    
    let firstItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let otherIncludedItemsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 8.5)
        label.textColor = .accentColor
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        clipsToBounds = true
        contentView.backgroundColor = .mainScreenBackgroundColor
        
        setupSubViews()
    }
    
    func setupSubViews() {
        contentView.addSubview(containerView)
        setupHourLabel()
        setupImageViewContainer()
        setupFirstItemImageView()
        setupOtherIncludedItemsLabel()
    }
    
    func setupHourLabel() {
        containerView.addSubview(hourLabel)
        
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            hourLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hourLabel.widthAnchor.constraint(lessThanOrEqualTo: containerView.widthAnchor),
            hourLabel.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor),
        ])
    }
    
    func setupImageViewContainer() {
        containerView.addSubview(imageViewContainer)
        let size: CGFloat = contentView.frame.height * 0.65
        
        NSLayoutConstraint.activate([
            imageViewContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 5),
            imageViewContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageViewContainer.heightAnchor.constraint(equalToConstant: size),
            imageViewContainer.widthAnchor.constraint(equalToConstant: size),
        ])
        
        imageViewContainer.layer.cornerRadius = size / 2
    }
    
    func setupFirstItemImageView() {
        imageViewContainer.addSubview(firstItemImageView)
        
        firstItemImageView.constrainEdgesToCorrespondingEdges(of: imageViewContainer, top: 6, leading: 6, bottom: -6, trailing: -6)
    }
    
    func setupOtherIncludedItemsLabel() {
        containerView.addSubview(otherIncludedItemsLabel)
        
        NSLayoutConstraint.activate([
            otherIncludedItemsLabel.topAnchor.constraint(equalTo: hourLabel.topAnchor),
            otherIncludedItemsLabel.leadingAnchor.constraint(equalTo: hourLabel.trailingAnchor, constant: 1),
            otherIncludedItemsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            otherIncludedItemsLabel.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor),
        ])
    }
}
