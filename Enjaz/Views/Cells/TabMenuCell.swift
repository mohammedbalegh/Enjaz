
import UIKit

class TabMenuCell: UICollectionViewCell {
    
	override var isSelected: Bool {
		didSet {
			label.textColor = isSelected ? .accent : .lowContrastGray
			bottomBorder.backgroundColor = isSelected ? .accent : .clear
		}
	}
	
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lowContrastGray
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
	
	let bottomBorder = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
		setupBottomBorder()
        setupLabel()
    }
	
	func setupBottomBorder() {
		addSubview(bottomBorder)
		bottomBorder.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
			bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
			bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
			bottomBorder.heightAnchor.constraint(equalToConstant: 2),
		])
	}
    
    func setupLabel() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
			label.bottomAnchor.constraint(equalTo: bottomBorder.topAnchor, constant: -5),
        ])
    }
	
}
