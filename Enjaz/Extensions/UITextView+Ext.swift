import UIKit

extension UITextView {
    func setTextViewDirectionToMatchSuperView() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
        if layoutDirection == .rightToLeft {
            textAlignment = .right
        }
    }
}
