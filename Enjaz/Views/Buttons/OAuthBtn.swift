import UIKit

class OAuthBtn : UIButton {
	
	enum oAuthBtnType {
		case twitter, apple
	}
	
	var type : oAuthBtnType?
	let size : CGFloat = 45
	
	init(type: oAuthBtnType) {
		super.init(frame: .zero)
		self.type = type
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
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
