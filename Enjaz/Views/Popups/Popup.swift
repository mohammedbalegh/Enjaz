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
	var hideOnOverlayTap: Bool
	var onPopupDismiss: (() -> Void)?
	
	init(hideOnOverlayTap: Bool = true) {
		self.hideOnOverlayTap = hideOnOverlayTap
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: views setups
			
	func setup() {
		fillScreen()
		
		addSubview(blurOverlay)
		blurOverlay.fillSuperView()
		if hideOnOverlayTap { setOverlayHideGestureRecognizer() }
		
		addSubview(popupContainer)
		animatePopupContainerIn()
		
		onPopupContainerShown()
	}
		
	// @absract
	func onPopupContainerShown() {
		fatalError("Subclasses need to implement the `setPopupContainerConstraints()` method.")
	}
	
	// MARK: Tools
	
	func setOverlayHideGestureRecognizer() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
		blurOverlay.addGestureRecognizer(tap)
	}
	
	func show() {
		let window = UIApplication.shared.windows[0]
		window.addSubview(self);
        DispatchQueue.main.async {
            self.setup()
        }
	}
	
	@objc func hide() {
		guard superview != nil else { return }
		
		animatePopupContainerOut() { finished in
			self.removeFromSuperview()
			if let onPopupDismiss = self.onPopupDismiss {
				onPopupDismiss()
			}
		}
	}
	
	func animatePopupContainerIn() {
		self.blurOverlay.alpha = 1
		
		UIView.animate(withDuration: 0.2) {
			self.popupContainer.animate(opacityTo: 1, andScaleTo: 1)
		}
	}
	
	func animatePopupContainerOut(onAnimationComplete: @escaping (Bool) -> Void) {
		UIView.animate(
			withDuration: 0.1,
			animations: {
				self.popupContainer.animate(opacityTo: 0, andScaleTo: self.popupContainerInitialScale)
				self.blurOverlay.alpha = 0
			},
			completion: onAnimationComplete
		)
	}
}
