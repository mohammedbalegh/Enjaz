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
            cardView.cardBody.descriptionLabel.text = viewModel.item_description
            setDateAndTimeLabelText(viewModel)
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
    
    func setDateAndTimeLabelText(_ viewModel: ItemModel) {
        let itemDate = Date(timeIntervalSince1970: viewModel.date)
        let dateFormat: String = {
            if viewModel.isRepeated { return "d/M/yy" }
            if Calendar.current.isDateInToday(itemDate) { return "hh:00  aa" }
            return "d/M/yyyy hh:00  aa"
        }()
        
        let readableStartDate = DateAndTimeTools.getReadableDate(from: itemDate, withFormat: dateFormat, calendarIdentifier: Calendar.current.identifier)
        let readableEndDate: String = {
            guard viewModel.isRepeated else { return "" }
            
            let itemEndDate = Date(timeIntervalSince1970: viewModel.endDate)
            return DateAndTimeTools.getReadableDate(from: itemEndDate, withFormat: dateFormat, calendarIdentifier: Calendar.current.identifier)
        }()
        
        let from = NSLocalizedString("from", comment: "")
        let to = NSLocalizedString("to", comment: "")
        
        let rangeDate = "\(from) \(readableStartDate) \(to) \(readableEndDate)".attributedStringWithColor([from, to], color: .accentColor, withSize: 11)
        
        let itemReadableDate = viewModel.isRepeated
            ? rangeDate
            : NSAttributedString(string: readableStartDate)
        
        cardView.cardBody.dateAndTimeLabel.attributedText = itemReadableDate
    }
    
}
