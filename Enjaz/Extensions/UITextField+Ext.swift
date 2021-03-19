import UIKit

extension UITextField {
	func setTextFieldDirectionToMatchSuperView() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
		if layoutDirection == .rightToLeft {
			textAlignment = .right
		}
	}
}
