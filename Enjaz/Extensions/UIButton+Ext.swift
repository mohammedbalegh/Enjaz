import UIKit

extension UIButton {
    func setTextViewDirectionToMatchSuperView() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
        if layoutDirection == .rightToLeft {
            contentHorizontalAlignment = .right
        }
    }
}
