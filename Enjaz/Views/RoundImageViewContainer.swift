import UIKit

class RoundImageViewContainer: RoundView {
	
	var image: UIImage? {
		didSet {
			imageView.image = image
		}
	}
	
	let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupImageView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupImageView() {
		addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
			imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
		])
	}
	
}
