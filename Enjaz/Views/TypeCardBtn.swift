
import UIKit

class TypeCardBtn: UIButton {
	
    var id = -1
	
    let typeImageContainer = RoundImageViewContainer()
    
    let typeTitle: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.textColor = .highContrastText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeDescription: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .highContrastGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
	
    var delegate: AdditionTypeScreenCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        addTarget(self, action: #selector(handleBtnTap), for: .touchUpInside)
        
        self.backgroundColor = .secondaryBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupSubviews()
    }
    
    func setupSubviews() {
        setupTypeImage()
        setupTypeTitle()
        setupTypeDescription()
    }
    
    func setupTypeImage() {
        addSubview(typeImageContainer)
		typeImageContainer.translatesAutoresizingMaskIntoConstraints = false
		typeImageContainer.backgroundColor = .background
		
        NSLayoutConstraint.activate([
            typeImageContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            typeImageContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.063),
			typeImageContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
			typeImageContainer.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45)
        ])
    }
    
    func setupTypeTitle() {
        addSubview(typeTitle)
                
        NSLayoutConstraint.activate([
            typeTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            typeTitle.topAnchor.constraint(equalTo: typeImageContainer.bottomAnchor, constant: self.frame.height * 0.073),
            typeTitle.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            typeTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])
    }
    
    func setupTypeDescription() {
        addSubview(typeDescription)
        
        let width = self.frame.width * 0.756
        
        NSLayoutConstraint.activate([
            typeDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            typeDescription.topAnchor.constraint(equalTo: typeTitle.bottomAnchor, constant: self.frame.height * 0.073),
            typeDescription.widthAnchor.constraint(equalToConstant: width),
            typeDescription.heightAnchor.constraint(equalToConstant: width * 0.317)
        ])
    }
	
    @objc func handleBtnTap() {
        delegate?.handleCardSelection(cardId: id)
    }
	
}
