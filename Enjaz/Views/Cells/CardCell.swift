import UIKit
import Realm

class CardCell: UICollectionViewCell {
    
    var viewModel: ItemModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            image.image = UIImage(named: viewModel.image_id)
            cardInfo.typeLabel.text = "ديني"
            cardInfo.titleLabel.text = viewModel.name
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:MM. aa"
            let result = formatter.string(from: date)
            cardInfo.timeLabel.text = result
        }
    }
    
    let cardInfo: CardInfoView = {
        let view = CardInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardBody: CardBodyView = {
        let view = CardBodyView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.asCircle()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.asCircle()
        button.setTitle("✓", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    static let reuseID = "cardCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCardBody()
        setupImage()
        setupCardInfo()
        setupCheckMark()
    }
    
    func setupCheckMark() {
        addSubview(checkButton)
        
        checkButton.isHidden = true
        
        NSLayoutConstraint.activate([
            checkButton.bottomAnchor.constraint(equalTo: cardBody.bottomAnchor, constant: -(self.bounds.height * 0.05)),
            checkButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.15),
            checkButton.heightAnchor.constraint(equalToConstant: self.bounds.width * 0.15)
        ])
        
    }
    
    func setupImage() {
        addSubview(image)
        let height = self.bounds.width * 0.409
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: height),
            image.heightAnchor.constraint(equalToConstant: height),
            image.bottomAnchor.constraint(equalTo: cardBody.topAnchor, constant: 10)
        
        ])
    }
    
    func setupCardBody() {
        addSubview(cardBody)
        
        NSLayoutConstraint.activate([
            cardBody.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardBody.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardBody.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardBody.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.7)
        ])
        
    }
    
    func setupCardInfo() {
        addSubview(cardInfo)
        
        NSLayoutConstraint.activate([
            cardInfo.leadingAnchor.constraint(equalTo: cardBody.leadingAnchor),
            cardInfo.trailingAnchor.constraint(equalTo: cardBody.trailingAnchor),
            cardInfo.bottomAnchor.constraint(equalTo: cardBody.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.013)),
            cardInfo.topAnchor.constraint(equalTo: cardBody.topAnchor, constant: (LayoutConstants.screenHeight * 0.04))
        ])
    }
    
    
}
