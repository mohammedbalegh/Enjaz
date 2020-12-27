import UIKit
import Realm

class CardCell: UICollectionViewCell {
    
    var viewModel: ItemModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            cardView.image.image = UIImage(named: (ImageIdConstants[viewModel.image_id]) ?? "")
            cardView.cardBody.categoryLabel.text = ItemCategoryConstants[viewModel.category]
            cardView.cardBody.titleLabel.text = viewModel.name
            let date = NSDate(timeIntervalSince1970: viewModel.date)
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:00  aa"
            let result = formatter.string(from: date as Date)
            cardView.cardBody.descriptionLabel.text = viewModel.item_description
            cardView.cardBody.timeLabel.text = result
        }
    }
    
    var cardView: CardView = {
        let view = CardView()
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
    
    
    
<<<<<<< HEAD
    func setupImage() {
        addSubview(image)
        image.backgroundColor = UIColor(hex: 0xF7F7F7)
        image.contentMode = .scaleAspectFit
        let height = self.bounds.width * 0.409
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: height),
            image.heightAnchor.constraint(equalToConstant: height),
            image.bottomAnchor.constraint(equalTo: cardBody.topAnchor, constant: 15)
        
        ])
=======
    func setupSubviews() {
        setupCardView()
>>>>>>> origin/main
    }
    
    func setupCardView() {
        addSubview(cardView)
        
        DispatchQueue.main.async {
            self.cardView.cardBody.titleLabel.topAnchor.constraint(equalTo: self.cardView.image.bottomAnchor, constant: (LayoutConstants.screenHeight * 0.015)).isActive = true
        }
       
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
    }
    
}
