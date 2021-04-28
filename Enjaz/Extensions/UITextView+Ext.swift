import UIKit

extension UITextView {
    func setTextViewDirectionToMatchUserInterface() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
		if layoutDirection == .leftToRight {
			self.makeTextWritingDirectionLeftToRight(self)
		} else {
			self.makeTextWritingDirectionRightToLeft(self)
		}
    }
}
