import UIKit

class ItemCardView: UIView {
    
    var viewModel: ItemModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
			cardBody.item = viewModel
			
            if let imageName = RealmManager.retrieveItemImageSourceById(viewModel.image_id) {
                imageView.image = UIImage.getImageFrom(imageName)
            } else {
                imageView.image = nil
            }
            
            let itemCategory = RealmManager.retrieveItemCategoryById(viewModel.category)
						
            cardBody.categoryLabel.text = " \(itemCategory?.localized_name ?? "") "
            cardBody.titleLabel.text = viewModel.name
            cardBody.descriptionLabel.text = viewModel.item_description
            setDateAndTimeLabelText(viewModel)
        }
    }
    
    
    let imageContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hex: 0xF2F2F2)
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var cardBody: CardBodyView = {
        let view = CardBodyView()
        view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = frame.width * 0.08
		view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
		view.layer.borderWidth = 0.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupImageContainer()
        setupImageView()
        setupCardBody()
    }
    
    func setupImageContainer() {
        addSubview(imageContainer)
        
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: topAnchor),
            imageContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.41),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
        ])
        
        layoutIfNeeded()
        imageContainer.layer.cornerRadius = imageContainer.frame.height / 2;
    }

    func setupImageView() {
        imageContainer.addSubview(imageView)
        
        let inset = imageContainer.frame.width * 0.15
        
        imageView.constrainEdgesToCorrespondingEdges(of: imageContainer, top: inset, leading: inset, bottom: -inset, trailing: -inset)
    }
    
    func setupCardBody() {
        addSubview(cardBody)
                
        NSLayoutConstraint.activate([
            cardBody.topAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: frame.height * 0.06),
            cardBody.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardBody.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardBody.trailingAnchor.constraint(equalTo: self.trailingAnchor),
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
        
        let rangeDate = "\(from) \(readableStartDate) \(to) \(readableEndDate)".attributedStringWithColor([from, to], color: .accentColor, stringSize: 11)
        
        let itemReadableDate = viewModel.isRepeated
            ? rangeDate
            : NSAttributedString(string: readableStartDate)
        
        cardBody.dateAndTimeLabel.attributedText = itemReadableDate
    }
}
