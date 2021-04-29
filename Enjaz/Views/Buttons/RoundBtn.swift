import UIKit

class RoundBtn: UIButton {
	
	var size = LayoutConstants.screenWidth * 0.16
	
	init(image: UIImage?, size: CGFloat? = nil) {
		super.init(frame: .zero)
		if let image = image {
			setImage(image, for: .normal)
		}
		if let size = size {
			self.size = size
		}
		clipsToBounds = true
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMoveToWindow() {
		guard window != nil else { return }
		
		NSLayoutConstraint.activate([
			heightAnchor.constraint(equalToConstant: size),
			widthAnchor.constraint(equalToConstant: size),
		])
	}
	
	func setup() {
		translatesAutoresizingMaskIntoConstraints = false
		
		imageView?.contentMode = .scaleAspectFill
		
		backgroundColor = .accent
		setTitleColor(.secondaryBackground, for: .normal)
		
		layer.cornerRadius = size / 2
	}
}
