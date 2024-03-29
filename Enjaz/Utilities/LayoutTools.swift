import UIKit

struct LayoutTools {
    
    static func getCurrentLayoutDirection(for view: UIView) -> UIUserInterfaceLayoutDirection {
        let attribute = view.semanticContentAttribute
        let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
        return layoutDirection
    }
    
    static func mapUIDirectionalRectCornerToUIRectCorner(_ directionalCorner: UIDirectionalRectCorner, forView view: UIView) -> UIRectCorner? {
        let layoutDirection = getCurrentLayoutDirection(for: view)
        let layoutDirectionIsLeftToRight = layoutDirection == .leftToRight
        
        let map: [UIDirectionalRectCorner: UIRectCorner] = [
            .topLeading: layoutDirectionIsLeftToRight ? .topLeft : .topRight,
            .bottomLeading: layoutDirectionIsLeftToRight ? .bottomLeft : .bottomRight,
            .bottomTrailing: layoutDirectionIsLeftToRight ? .bottomRight : .bottomLeft,
            .topTrailing: layoutDirectionIsLeftToRight ? .topRight : .topLeft,
            .allCorners: .allCorners,
        ]
                
        return map[directionalCorner]
    }
    
    static func mapUIRectCornerToCACornerMask(_ corner: UIRectCorner) -> CACornerMask? {
        switch corner {
        case .topLeft: return .layerMinXMaxYCorner
        case .bottomLeft: return .layerMinXMinYCorner
        case .bottomRight: return .layerMaxXMinYCorner
        case .topRight: return .layerMaxXMaxYCorner
        default: return nil
        }
    }
    
}
