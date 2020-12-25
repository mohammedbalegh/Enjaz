
import UIKit

class CardBodyView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(18)
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
        label.font = label.font.withSize(15)
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
        label.textAlignment = .center
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.27),
            titleLabel.heightAnchor.constraint(equalTo: superview!.heightAnchor, multiplier: 0.1),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -(LayoutConstants.screenHeight * 0.035)),
        ])
    }
    
    func setupCategoryLabel() {
        addSubview(categoryLabel)
        
        DispatchQueue.main.async {
            self.categoryLabel.layer.cornerRadius = self.categoryLabel.frame.size.height/2;
        }
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            categoryLabel.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.4),
            categoryLabel.heightAnchor.constraint(equalTo: categoryLabel.widthAnchor, multiplier: 0.3)
        ])
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        
        descriptionLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            descriptionLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.2),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.06)
        ])
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)

        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.444),
            timeLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.7)

        ])
    }
    
    func setupCheckMark() {
        addSubview(checkButton)
        
        checkButton.isHidden = true
        let size = LayoutConstants.screenWidth * 0.059
        
        NSLayoutConstraint.activate([
            checkButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.012)),
            checkButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: size),
            checkButton.heightAnchor.constraint(equalToConstant: size)
        ])
        
    }
}


