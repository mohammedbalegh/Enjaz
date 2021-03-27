import UIKit

extension UITextField {
    func setTextFieldDirectionToMatchSuperView() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
        if layoutDirection == .rightToLeft {
            textAlignment = .right
        }
    }
    
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.cut) || action == #selector(UIResponderStandardEditActions.copy)
    }
    
}
