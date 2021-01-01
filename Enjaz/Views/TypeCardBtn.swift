
import UIKit

class TypeCardBtn: UIButton {

    var id = 1
    
    var selectedId: Int = -1 {
        didSet {
            onSelectedIdChange()
        }
    }
    
    let typeImage: UIImageView = {
        let image = UIImageView()
        image.roundAsCircle()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let typeTitle: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.textColor = UIColor(hex: 0x011942)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeDescription: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .darkGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkMark: UIImageView = {
        let image = UIImageView()
        image.roundAsCircle()
        image.image = UIImage(named: "checkMarkIcon")
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var delegate: AdditionTypeScreenCardDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        addTarget(self, action: #selector(onViewTap), for: .touchUpInside)
        
        self.layer.borderColor = UIColor.accentColor.cgColor
        self.backgroundColor = .white
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
        setupCheckMark()
    }
    
    func setupTypeImage() {
        addSubview(typeImage)
        
        let size = self.frame.width * 0.457
        
        NSLayoutConstraint.activate([
            typeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            typeImage.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.063),
            typeImage.widthAnchor.constraint(equalToConstant: size),
            typeImage.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupTypeTitle() {
        addSubview(typeTitle)
        
        let width = self.frame.width * 0.267
        
        NSLayoutConstraint.activate([
            typeTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            typeTitle.topAnchor.constraint(equalTo: typeImage.bottomAnchor, constant: self.frame.height * 0.073),
            typeTitle.widthAnchor.constraint(equalToConstant: width),
            typeTitle.heightAnchor.constraint(equalToConstant: width * 0.6)
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
    
    func setupCheckMark() {
        addSubview(checkMark)
        
        let size = self.frame.width * 0.111
        let space = self.frame.width * 0.06
        
        NSLayoutConstraint.activate([
            checkMark.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space),
            checkMark.topAnchor.constraint(equalTo: self.topAnchor, constant: space),
            checkMark.widthAnchor.constraint(equalToConstant: size),
            checkMark.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func onSelectedIdChange() {
        if id == selectedId {
            layer.borderWidth = 1
            checkMark.isHidden = false
        } else {
            layer.borderWidth = 0
            checkMark.isHidden = true
        }
    }
    
    @objc func onViewTap() {
        delegate?.onCardSelect(cardId: id)
    }
    
    
}
