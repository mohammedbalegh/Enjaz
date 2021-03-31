import UIKit

extension UITextView {
    func setTextViewDirectionToMatchSuperView() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
        if layoutDirection == .rightToLeft {
            textAlignment = .right
        }
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
