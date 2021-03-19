import UIKit

class BottomSheetView: UIView {
    var height = LayoutConstants.screenHeight * 0.5
    
    lazy var overlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.applyLightShadow()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    let thumb: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemGray2
        
        return view
    }()
    
    lazy var contentViewYOriginWhenPresenting = LayoutConstants.screenHeight - height
    
    func setup() {
        let window = UIApplication.shared.windows[0]
        window.addSubview(self);
        fillSuperView()
    }
    
    override func layoutSubviews() {
        setupOverlay()
        setupContentView()
        setupThumb()
    }
    
    func setupOverlay() {
        addSubview(overlay)
        overlay.fillSuperView()
    }
    
    func setupContentView() {
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: height + 100),
        ])
    }
    
    func setupThumb() {
        contentView.addSubview(thumb)
        
        let height: CGFloat = 5
        thumb.layer.cornerRadius = height / 2
        
        NSLayoutConstraint.activate([
            thumb.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            thumb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thumb.heightAnchor.constraint(equalToConstant: height),
            thumb.widthAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let verticalTranslation = panGesture.translation(in: contentView).y
        let verticalVelocity = panGesture.velocity(in: contentView).y
        
        let translationFromOriginalYOrigin = contentView.frame.origin.y - contentViewYOriginWhenPresenting
        let translationDirectionIsUpwards = translationFromOriginalYOrigin < 0
        var translationMultiplier: CGFloat = 1
        
        if translationDirectionIsUpwards {
            let viewReachedUpwardsTranslation = abs(translationFromOriginalYOrigin) > 100
            translationMultiplier =  viewReachedUpwardsTranslation ? 0 : 0.1
        }
        
        contentView.frame.origin.y += verticalTranslation * translationMultiplier
        panGesture.setTranslation(.zero, in: contentView)
        
        if panGesture.state == .ended {
            let shouldSnapToBottom = verticalVelocity > 400 || translationFromOriginalYOrigin > height / 4
            
            if shouldSnapToBottom {
                let translationDuration = TimeInterval(translationFromOriginalYOrigin / verticalVelocity)
                dismiss(animated: true, withDuration: min(translationDuration, 0.25))
            } else {
                setContentViewYOrigin(to: contentViewYOriginWhenPresenting, animated: true, withDuration: 0.4, springLoaded: true)
            }
        }
    }
    
    // MARK: Tools
    
    func present(animated: Bool, withDuration duration: TimeInterval = 0.55) {
        guard superview == nil else { return }
        
        setup()
        superview!.layoutIfNeeded()

        overlay.alpha = 1
        setContentViewYOrigin(to: contentViewYOriginWhenPresenting, animated: animated, withDuration: duration, springLoaded: true)
    }
    
    func dismiss(animated: Bool, withDuration duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: animated ? duration : 0) { self.overlay.alpha = 0 }
        setContentViewYOrigin(to: LayoutConstants.screenHeight, animated: animated, withDuration: duration) { (_) in
            if self.superview != nil {
                self.removeFromSuperview()
                NSLayoutConstraint.deactivate(self.constraints)
            }
        }
    }
    
    private func setContentViewYOrigin(to YOrigin: CGFloat, animated: Bool, withDuration duration: TimeInterval = 0.4, springLoaded: Bool = false, completionHandler: ((Bool) -> Void)? = nil) {
        let duration = animated ? duration : 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: springLoaded ? 0.7 : 1, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
            self.contentView.frame.origin.y = YOrigin
        }, completion: completionHandler)
    }
}
