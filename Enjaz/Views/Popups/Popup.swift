import UIKit

class Popup: UIView {
    
	// MARK: Properties
	
	lazy var blurOverlay: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: blurEffectStyle)
		
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		
		return visualEffectView
	}()
    
	lazy var popupContainer: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.backgroundColor = .secondaryBackground
		view.layer.cornerRadius = 10
		view.alpha = 0
		view.scale(to: popupContainerInitialScale)
		
		return view
	}()
	
	internal lazy var overlayTapGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOverlayAndDismissBtnTab))
	
	var blurEffectStyle: UIBlurEffect.Style {
		return traitCollection.userInterfaceStyle == .dark ? .light : .dark
	}
    
	let popupContainerInitialScale: CGFloat = 1.2
	var popupDismissalHandler: (() -> Void)?
	
	var hideOnOverlayTap: Bool = true {
		didSet {
			overlayTapGestureRecognizer.isEnabled = hideOnOverlayTap
		}
	}
		
	init() {
		super.init(frame: .zero)
		setupSubViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
	// MARK: views setups
			
	func setupSubViews() {
		addSubview(blurOverlay)
		blurOverlay.fillSuperView()
		
		addSubview(popupContainer)
        setupPopupContainer()
	}
	
	internal func setupPopupContainer() {
        popupContainer.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.3),
            popupContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.78),
        ])
    }
	
	@objc func handleOverlayAndDismissBtnTab() {
		dismiss(animated: true)
	}
	
	// MARK: Tools
			
	func present(animated: Bool) {
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		keyWindow?.addSubview(self)
				
		prepareForPresentation(animated)
				
		if animated {
			animatePopupContainerIn()
		} else {
			popupContainer.alpha = 1
		}
	}
	
	func dismiss(animated: Bool) {
		guard superview != nil else { return }
		
		func animationCompletionHandler(completed: Bool) {
			self.removeFromSuperview()
			self.popupDismissalHandler?()
		}
		
		if animated {
			animatePopupContainerOut(completionHandler: animationCompletionHandler)
		} else {
			animationCompletionHandler(completed: true)
		}
	}
	
	internal func prepareForPresentation(_ animated: Bool) {
		if !(blurOverlay.gestureRecognizers?.contains(overlayTapGestureRecognizer) ?? false) {
			blurOverlay.addGestureRecognizer(overlayTapGestureRecognizer)
		}
		
		popupContainer.scale(to: animated ? popupContainerInitialScale : 1)
		blurOverlay.alpha = 1
		
		fillScreen()
	}
	
	internal func animatePopupContainerIn() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
			self.popupContainer.alpha = 1
			self.popupContainer.scale(to: 1)
		}
	}
	
	func animatePopupContainerOut(completionHandler: @escaping (Bool) -> Void) {
		UIView.animate(
			withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn,
			animations: {
				self.popupContainer.alpha = 0
				self.popupContainer.scale(to: self.popupContainerInitialScale)
				self.blurOverlay.alpha = 0
			},
			completion: completionHandler
		)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		blurOverlay.effect = UIBlurEffect(style: blurEffectStyle)
	}
}
