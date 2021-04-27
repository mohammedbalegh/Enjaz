import UIKit

class RoundView: UIView {

	override var bounds: CGRect {
		didSet {
			layer.cornerRadius = bounds.height / 2
			clipsToBounds = true
		}
	}

}
