import UIKit

class LayoutTools {
    
    static func forceLayoutDirectionTo(_ direction: UIUserInterfaceLayoutDirection) {
        UIView.appearance().semanticContentAttribute = direction == .leftToRight ? .forceLeftToRight : .forceRightToLeft
    }

    static func getCurrentLayoutDirectionFor(_ view: UIView) -> UIUserInterfaceLayoutDirection {
        let attribute = view.semanticContentAttribute
        let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
        return layoutDirection
    }
    
}
