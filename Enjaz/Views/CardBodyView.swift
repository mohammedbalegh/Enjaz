
import UIKit

class CardBodyView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        label.textColor = UIColor(hex: 0x011942)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.numberOfLines = 1
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 0.5
        label.layer.masksToBounds = true
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.font = label.font.withSize(12)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.minimumScaleFactor = 0.1
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.roundAsCircle()
        button.setTitle("✓", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        updateMask()
    }
    
    override func didMoveToWindow() {
        guard window != nil else { return }
        guard superview != nil else { return }
        
        setupSubviews()
    }
    
    private func updateMask() {
        let center = CGPoint(x: bounds.midX, y: bounds.minY - 15)

        let path = UIBezierPath(rect: bounds)
        path.addArc(withCenter: center, radius: bounds.width / 4, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.path = path.cgPath

        layer.mask = mask
    }
    
    func setupSubviews() {
        setupTitleLabel()
        setupCategoryLabel()
        setupTimeLabel()
        setupDescriptionLabel()
        setupCheckMark()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        guard let superview = superview as? ItemCardView else { return }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.9),
            titleLabel.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.1),
            titleLabel.topAnchor.constraint(equalTo: superview.imageContainer.bottomAnchor, constant: 20),
        ])
    }
    
    func setupCategoryLabel() {
        addSubview(categoryLabel)
        
        var superviewWidth =  superview?.superview?.frame.width ?? 0
        
        if superviewWidth == 0 {
            superviewWidth = LayoutConstants.screenWidth * 0.8
        }
        
        let width = superviewWidth * 0.4
        let height: CGFloat = width * 0.3
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: width),
            categoryLabel.heightAnchor.constraint(equalToConstant: height)
        ])
        
        categoryLabel.layer.cornerRadius = height / 2;
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
                
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)

        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.444),
            timeLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.7),
        ])
    }
    
    func setupCheckMark() {
        addSubview(checkButton)
        
        checkButton.isHidden = true
        let size = LayoutConstants.screenWidth * 0.059
        
        
        
        layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            checkButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            checkButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: size),
            checkButton.heightAnchor.constraint(equalToConstant: size)
        ])
        
        checkButton.layer.cornerRadius = size / 2
        
    }
}


