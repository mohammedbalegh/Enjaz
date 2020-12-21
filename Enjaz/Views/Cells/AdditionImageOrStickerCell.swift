import UIKit

class AdditionImageOrStickerCell: UICollectionViewCell {
	
	var viewModel: AdditionImageOrStickerCellModel? {
		didSet {
			imageView.image = viewModel?.image
			guard let isSelected = viewModel?.isSelected else { return }
			layer.borderWidth = isSelected ? 0.5 : 0
			checkMarkImageView.isHidden = !isSelected
		}
	}
	
	let imageView = UIImageView(frame: .zero)
	let checkMarkImageView = UIImageView(image: UIImage(named: "smallCheckMarkImage"))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor(hex: 0xF7F7F7)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		layer.cornerRadius = 10
		layer.borderColor = UIColor.accentColor.cgColor
		setupImageView()
		setupCheckMarkImageView()
	}
	
	func setupImageView() {
		addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.contentMode = .scaleAspectFit
		
		NSLayoutConstraint.activate([
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
			imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
		])
	}
	
	func setupCheckMarkImageView() {
		checkMarkImageView.isHidden = true
		addSubview(checkMarkImageView)
		checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
		
		let size: CGFloat = 20
		
		checkMarkImageView.constrainToSuperviewCorner(cornerPosition: .topLeft)
		NSLayoutConstraint.activate([
			checkMarkImageView.widthAnchor.constraint(equalToConstant: size),
			checkMarkImageView.heightAnchor.constraint(equalToConstant: size),
		])
	}
}
