import UIKit

class RoundBtn: UIButton {
	
	override var bounds: CGRect {
		didSet {
			layer.cornerRadius = bounds.height / 2
			clipsToBounds = true
		}
	}
	
}
