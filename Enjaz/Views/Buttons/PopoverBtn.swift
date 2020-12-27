import UIKit

class PopoverBtn: UIButton {

	let label: UILabel = {
		let label = UILabel(frame: .zero)
		
		label.textColor = .gray
		label.font = .systemFont(ofSize: 16)
		
		return label
	}()
	
	let dropdownArrow: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "arrowIcon"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.contentMode = .scaleAspectFit
		imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = .gray
		
		return imageView
	}()
	
	lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [label, dropdownArrow])
		stackView.frame = frame
		
		stackView.distribution = .fillProportionally
		stackView.alignment = .center
		
		return stackView
	}()
	
	override var tintColor: UIColor! {
		didSet {
			label.textColor = tintColor
			dropdownArrow.tintColor = tintColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		stackView.isUserInteractionEnabled = false
		addSubview(stackView)
		
		if frame == .zero {
			stackView.translatesAutoresizingMaskIntoConstraints = false
			stackView.fillSuperView()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
