import UIKit

class Popup: UIView {
    
	// MARK: Properties
	
	let blurOverlay: UIVisualEffectView = {
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
	var popupDismissalHandler: (() -> Void)?
	
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
		
		popupContainerDidShow()
	}
		
	// @absract
	func popupContainerDidShow() {}
	
	// MARK: Tools
	
	func setOverlayHideGestureRecognizer() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
		blurOverlay.addGestureRecognizer(tap)
	}
	
	func present() {
		let window = UIApplication.shared.windows[0]
		window.addSubview(self);
        setup()
	}
	
	@objc func hide() {
		guard superview != nil else { return }
		
		animatePopupContainerOut() { finished in
			self.removeFromSuperview()
            self.popupDismissalHandler?()
		}
	}
	
	func animatePopupContainerIn() {
		self.blurOverlay.alpha = 1
		
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
			self.popupContainer.animate(opacityTo: 1, andScaleTo: 1)
		}
	}
	
	func animatePopupContainerOut(CompletionHandler: @escaping (Bool) -> Void) {
		UIView.animate(
			withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn,
			animations: {
				self.popupContainer.animate(opacityTo: 0, andScaleTo: self.popupContainerInitialScale)
				self.blurOverlay.alpha = 0
			},
			completion: CompletionHandler
		)
	}
}
