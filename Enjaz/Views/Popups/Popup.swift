import UIKit

class Popup: UIView {

	// MARK: Properties
	
	var blurOverlay: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: .dark)
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		
		return visualEffectView
	}()
	lazy var popupContainer: UIView = {
		let view = UIView(frame: .zero)
		
		view.backgroundColor = .white
		view.layer.cornerRadius = 10
		view.alpha = 0
		view.transform = CGAffineTransform(scaleX: popupContainerInitialScale, y: popupContainerInitialScale)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	let popupContainerInitialScale: CGFloat = 1.2

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: views setups
		
	func setup() {
		fillSuperView()
		
		addSubview(blurOverlay)
		blurOverlay.fillSuperView()
		
		addSubview(popupContainer)
		animatePopupContainerIn()
		
		onPopupContainerShown()
	}
		
	// @absract
	func onPopupContainerShown() {
		fatalError("Subclasses need to implement the `setPopupContainerConstraints()` method.")
	}
	
	// MARK: Tools
	
	func show(inside superview: UIView) {
		superview.addSubview(self)
		setup()
	}
	
	func hide() {
		guard superview != nil else { return }
		
		animatePopupContainerOut() { finished in
			self.removeFromSuperview()
		}
	}
	
	func animatePopupContainerIn() {
		UIView.animate(withDuration: 0.2) {
			self.popupContainer.animate(opacityTo: 1, andScaleTo: 1)
		}
	}
	
	func animatePopupContainerOut(onAnimationComplete: @escaping (Bool) -> Void) {
		UIView.animate(
			withDuration: 0.2,
			animations: {
				self.popupContainer.animate(opacityTo: 0, andScaleTo: self.popupContainerInitialScale)
			},
			completion: onAnimationComplete
		)
	}
}
