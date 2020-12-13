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
		resetPopupContainerAnimationState(container: view)
		
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
	
	override func didMoveToWindow() {
		if window == nil {
			resetPopupContainerAnimationState(container: popupContainer)
			return
		}
		
		setup()
		setupBlurOverlay()
		setupPopupContainer()
	}
	
	// MARK: views setups
	
	
	func setup() {
		fillSuperView()
	}
	
	func setupPopupContainer() {
		addSubview(popupContainer)

		UIView.animate(withDuration: 0.2) {
			self.popupContainer.animate(opacityTo: 1, andScaleTo: 1)
		}
		
		setPopupContainerConstraints()
	}
	
	func setPopupContainerConstraints() {
		fatalError("setPopupContainerConstraints() has not been implemented")
	}
	
	func setupBlurOverlay() {
		addSubview(blurOverlay)
		
		blurOverlay.constrainEdgesToCorrespondingEdges(of: self, top: 0, leading: 0, bottom: 0, trailing: 0)
	}
	
	// MARK: Tools
	
	func resetPopupContainerAnimationState(container: UIView) {
		container.alpha = 0
		container.transform = CGAffineTransform(scaleX: popupContainerInitialScale, y: popupContainerInitialScale)
	}
}
