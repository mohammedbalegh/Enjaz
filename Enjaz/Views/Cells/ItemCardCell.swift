import UIKit
import Realm

class ItemCardCell: UICollectionViewCell {
    
    var viewModel: ItemModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            if let imageName = imageIdConstants[viewModel.image_id] {
                cardView.imageView.image = UIImage(named: imageName)
            } else {
                cardView.imageView.image = nil
            }
            
            let itemCategory = RealmManager.retrieveItemCategoryById(viewModel.category)
            
            cardView.cardBody.categoryLabel.text = itemCategory?.localized_name
            cardView.cardBody.titleLabel.text = viewModel.name
            let date = Date(timeIntervalSince1970: viewModel.date)
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:00  aa"
            let result = formatter.string(from: date)
            cardView.cardBody.descriptionLabel.text = viewModel.item_description
            cardView.cardBody.timeLabel.text = result
        }
    }
    
    var cardView: ItemCardView = {
        let view = ItemCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let reuseID = "cardCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func didMoveToWindow() {
        guard window != nil else { return }
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCardView()
    }
    
    func setupCardView() {
        addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
}
