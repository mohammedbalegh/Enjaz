import UIKit

class OAuthBtn : UIButton {
	
	enum oAuthBtnType {
		case twitter, apple
	}
	
	var type : oAuthBtnType?
	let size : CGFloat = 45
		
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init(type: oAuthBtnType) {
		super.init(frame: .zero)
		self.type = type
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	override func didMoveToWindow() {
		guard window != nil else { return }
		setup()
	}
	
	func setup() {
		if let type = type {
			switch type {
				case .twitter:
					setBackgroundImage(#imageLiteral(resourceName: "twitterOAuthImage"), for: .normal)

				case .apple:
					setBackgroundImage(#imageLiteral(resourceName: "AppleOAUthImage"), for: .normal)
			}
		}
		
		NSLayoutConstraint.activate([
			heightAnchor.constraint(equalToConstant: size),
			widthAnchor.constraint(equalToConstant: size),
		])
	}
}
