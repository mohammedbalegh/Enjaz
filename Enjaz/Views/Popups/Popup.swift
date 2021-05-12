import UIKit

class Popup: UIView {
    
	// MARK: Properties
	
	lazy var blurOverlay: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: blurEffectStyle)
		
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		
		return visualEffectView
	}()
    
	lazy var dismissBtn: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(handleOverlayAndDismissBtnTab), for: .touchUpInside)
		button.imageView?.contentMode = .scaleAspectFit
		
		return button
	}()
	
	lazy var contentView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.backgroundColor = .secondaryBackground
		view.layer.cornerRadius = 18
		view.alpha = 0
		view.scale(to: contentViewInitialScale)
		
		return view
	}()
	
	internal lazy var overlayTapGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOverlayAndDismissBtnTab))
	
	var blurEffectStyle: UIBlurEffect.Style {
		return traitCollection.userInterfaceStyle == .dark ? .light : .dark
	}
    
	let contentViewInitialScale: CGFloat = 1.2
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
		
		setupDismissBtn()
		addSubview(contentView)
        setupContentView()
	}
	
	internal func setupDismissBtn() {
		addSubview(dismissBtn)
		
		NSLayoutConstraint.activate([
			dismissBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
			dismissBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
			dismissBtn.heightAnchor.constraint(equalToConstant: 18),
			dismissBtn.widthAnchor.constraint(equalToConstant: 18),
		])
	}
	
	internal func setupContentView() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.15),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.78),
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
			animateContentViewIn()
		} else {
			contentView.alpha = 1
		}
	}
	
	func dismiss(animated: Bool) {
		guard superview != nil else { return }
		
		func animationCompletionHandler(completed: Bool) {
			self.removeFromSuperview()
			self.popupDismissalHandler?()
		}
		
		if animated {
			animateContentViewOut(completionHandler: animationCompletionHandler)
		} else {
			animationCompletionHandler(completed: true)
		}
	}
	
	internal func prepareForPresentation(_ animated: Bool) {
		if !(blurOverlay.gestureRecognizers?.contains(overlayTapGestureRecognizer) ?? false) {
			blurOverlay.addGestureRecognizer(overlayTapGestureRecognizer)
		}
		
		contentView.scale(to: animated ? contentViewInitialScale : 1)
		blurOverlay.alpha = 1
		dismissBtn.alpha = 1
		
		fillScreen()
	}
	
	internal func animateContentViewIn() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
			self.contentView.alpha = 1
			self.contentView.scale(to: 1)
		}
	}
	
	func animateContentViewOut(completionHandler: @escaping (Bool) -> Void) {
		UIView.animate(
			withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn,
			animations: {
				self.contentView.alpha = 0
				self.contentView.scale(to: self.contentViewInitialScale)
				self.blurOverlay.alpha = 0
				self.dismissBtn.alpha = 0
			},
			completion: completionHandler
		)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		blurOverlay.effect = UIBlurEffect(style: blurEffectStyle)
	}
}
