import UIKit

extension UIStackView {
	func removeAllSubViews() {
		arrangedSubviews.forEach {
			self.removeArrangedSubview($0)
			NSLayoutConstraint.deactivate($0.constraints)
			$0.removeFromSuperview()
		}
	}	
}
