import UIKit

class CircularView: UIView {

	override var frame: CGRect {
		didSet {
			layer.cornerRadius = frame.height / 2
		}
	}
	
}
