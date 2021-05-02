import UIKit
import SPAlert

class ItemCardBodyView: UIView {
	var item: ItemModel? {
		didSet {
			guard let item = item else { return }
			let checkBtnColor: UIColor = item.is_completed ? .accent : .systemGray
			checkBtn.setTitleColor(checkBtnColor, for: .normal)
			checkBtn.layer.borderColor = checkBtnColor.cgColor
		}
	}
	
	var checkBtnHandler: ((_ item: ItemModel, _ itemIsCompleted: Bool) -> Void)?
	
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.font = label.font.withSize(15)
		label.numberOfLines = 0
        label.textColor = .highContrastText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.65
        
        return label
    }()

	let categoryLabelContainer: RoundView = {
		let view = RoundView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.layer.borderWidth = 0.5
		view.layer.borderColor = UIColor.systemGray.cgColor
		
		return view
	}()
	
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.65
        
        return label
    }()
    
    let dateAndTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.65
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .accent
        label.font = label.font.withSize(12)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.minimumScaleFactor = 0.65
        label.isHidden = true
        
        return label
    }()
    
    let checkBtn: UIButton = {
		let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("✓", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.isHidden = true
		button.addTarget(self, action: #selector(handleCheckBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    var titleLabelTopConstraint: NSLayoutConstraint!
    var checkBtnHeightConstraint: NSLayoutConstraint!
    let checkBtnSize: CGFloat = 28
	
    var showsCheckBtn: Bool = false {
        didSet {
            checkBtnHeightConstraint.constant = showsCheckBtn ? checkBtnSize : 0
            checkBtn.isHidden = !showsCheckBtn
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateMask()
			titleLabelTopConstraint.constant = (bounds.width / 4 - 15) + 5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondaryBackground
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
		setupCategoryLabelContainer()
        setupCategoryLabel()
        setupCheckBtn()
        setupTimeLabel()
        setupDescriptionLabel()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabelTopConstraint,
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 20),
        ])
    }
    
	func setupCategoryLabelContainer() {
		addSubview(categoryLabelContainer)
		let height: CGFloat = categoryLabel.font.pointSize + 8
		
		NSLayoutConstraint.activate([
			categoryLabelContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
			categoryLabelContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
			categoryLabelContainer.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.4),
			categoryLabelContainer.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.95),
			categoryLabelContainer.heightAnchor.constraint(equalToConstant: height)
		])
	}
	
    func setupCategoryLabel() {
		categoryLabelContainer.addSubview(categoryLabel)
		categoryLabel.constrainEdgesToCorrespondingEdges(of: categoryLabelContainer, top: 0, leading: 10, bottom: 0, trailing: -10)
    }
    
    func setupCheckBtn() {
        addSubview(checkBtn)
        
        checkBtnHeightConstraint = checkBtn.heightAnchor.constraint(equalToConstant: showsCheckBtn ? checkBtnSize : 0)
        
        NSLayoutConstraint.activate([
            checkBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            checkBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkBtn.widthAnchor.constraint(equalToConstant: checkBtnSize),
            checkBtnHeightConstraint,
        ])
        
        checkBtn.layer.cornerRadius = checkBtnSize / 2
    }
    
    func setupTimeLabel() {
        addSubview(dateAndTimeLabel)
        
        NSLayoutConstraint.activate([
            dateAndTimeLabel.bottomAnchor.constraint(equalTo: checkBtn.topAnchor, constant: -7),
            dateAndTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateAndTimeLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.95),
            dateAndTimeLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: dateAndTimeLabel.topAnchor, constant: -5),
        ])
    }
    
	@objc func handleCheckBtnTap() {
		guard let item = item else { return }
		
		guard !item.is_completed else {
			let itemType = ItemType.getTypeById(id: item.type)
			let alertMessage = String(format: NSLocalizedString("%@ is already completed", comment: ""), itemType.localizedName)
			SPAlert.present(message: alertMessage, haptic: .error)
			return
		}
		
		let updatedItemIsCompletedValue = !item.is_completed
		checkBtnHandler?(item, updatedItemIsCompletedValue)
	}
	    
}
