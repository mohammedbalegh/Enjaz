import UIKit

extension UIStackView {
    
	func removeAllSubViews() {
		arrangedSubviews.forEach { subview in
			self.removeArrangedSubview(subview)
			NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
		}
	}
    
    func calculateHeightBasedOn(arrangedSubviewHeight: CGFloat) -> CGFloat {
        return calculateMainAxisLengthBasedOn(arrangedSubviewMainAxisLength: arrangedSubviewHeight)
    }
    
    func calculateWidthBasedOn(arrangedSubviewWidth: CGFloat) -> CGFloat {
        return calculateMainAxisLengthBasedOn(arrangedSubviewMainAxisLength: arrangedSubviewWidth)
    }
    
    private func calculateMainAxisLengthBasedOn(arrangedSubviewMainAxisLength: CGFloat) -> CGFloat {
        let numberOfArrangedSubviews = arrangedSubviews.count
        
        let totalArrangedSubviewsRealEstate = CGFloat(numberOfArrangedSubviews) * arrangedSubviewMainAxisLength
        let totalSpacingRealEstate = spacing * CGFloat((numberOfArrangedSubviews - 1))
        
        let stackViewHeight = totalArrangedSubviewsRealEstate + totalSpacingRealEstate
        
        return stackViewHeight
    }
    
}
