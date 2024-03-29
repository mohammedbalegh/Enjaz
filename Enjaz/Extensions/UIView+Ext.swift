import UIKit

// MARK: Constraints
extension UIView {
    func throwNoSuperviewError() {
        fatalError("Attempting to set constraints to a \(type(of: self)) before adding it to a superView")
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.invertedSystemBackground.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func fillScreen() {
        guard let superview = superview else {
            throwNoSuperviewError()
            return
        }
        disableAutoresizingMaskTranslationIfEnabled()
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight),
            widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
    
    func fillSuperView() {
        guard let superview = superview else {
            throwNoSuperviewError()
            return
        }
        
        disableAutoresizingMaskTranslationIfEnabled()
        fill(superview)
    }
    
    /// make `self` fill the specified `view` with specified margins.
    func fill(_ view: UIView, top: CGFloat=0, leading: CGFloat=0, bottom: CGFloat=0, trailing: CGFloat=0) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        constrainEdgesToCorrespondingEdges(of: view, top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    /// Constrain 4 edges of `self` to specified `view`.
    func constrainEdgesToCorrespondingEdges(of view: UIView, top: CGFloat?=nil, leading: CGFloat?=nil, bottom: CGFloat?=nil, trailing: CGFloat?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        if let top = top {
            topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
            
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
            
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        }
        
    }
    
    /// Constrain width and height of `self` to specified constants.
    func constrainDimensions(width: CGFloat?=nil, height: CGFloat?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        var constraints: [NSLayoutConstraint] = []
        
        if let width = width { constraints.append(widthAnchor.constraint(equalToConstant: width)) }
        if let height = height { constraints.append(heightAnchor.constraint(equalToConstant: height)) }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Constrain width and height of `self` to specified view with specified multipliers.
    func constrainDimensions(to view:UIView, widthMultiplier: CGFloat?=nil, heightMultiplier: CGFloat?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        var constraints: [NSLayoutConstraint] = []
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier))
        }
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func centerVertically(relativeTo view: UIView?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        guard let view = view ?? self.superview else {
            throwNoSuperviewError()
            return
        }
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func centerHorizontally(relativeTo view: UIView?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        guard let view = view ?? self.superview else {
            throwNoSuperviewError()
            return
        }
        
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// Centers the view both vertically and horizontally relative to the specified `view` or superview.
    func center(relativeTo view: UIView?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        guard let view = view ?? self.superview else {
            throwNoSuperviewError()
            return
        }
        centerVertically(relativeTo: view)
        centerHorizontally(relativeTo: view)
    }
    
    func constrainToSuperviewCorner(at cornerPosition: UIDirectionalRectCorner) {
        guard let superview = superview else {
            throwNoSuperviewError()
            return
        }
        
        disableAutoresizingMaskTranslationIfEnabled()
        
        let cornerRadius = superview.layer.cornerRadius
        let cornerRadiusInset = cornerRadius / 4
        
        switch cornerPosition {
        case .topLeading:
            NSLayoutConstraint.activate([
                centerYAnchor.constraint(equalTo: superview.topAnchor, constant: cornerRadiusInset),
                centerXAnchor.constraint(equalTo: superview.leadingAnchor, constant: cornerRadiusInset),
            ])
            
        case .bottomLeading:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.leadingAnchor, constant: cornerRadiusInset),
                centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: -cornerRadiusInset),
            ])
            
        case .bottomTrailing:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.trailingAnchor, constant: -cornerRadiusInset),
                centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: -cornerRadiusInset),
            ])
            
        case .topTrailing:
            NSLayoutConstraint.activate([
                centerYAnchor.constraint(equalTo: superview.topAnchor, constant: cornerRadiusInset),
                centerXAnchor.constraint(equalTo: superview.trailingAnchor, constant: -cornerRadiusInset),
            ])
            
        default:
            fatalError("View cannot be constrained to more the one corner.")
        }
    }
    
    private func disableAutoresizingMaskTranslationIfEnabled() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addTopBorder(withColor color: UIColor, andWidth width: CGFloat) {
        let border = UIView()
		border.tag = 1001
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
		self.addSubview(border)
    }
    
    func addRightBorder(withColor color: UIColor, andWidth width: CGFloat) {
        let border = UIView()
		border.tag = 1002
        border.backgroundColor = color
        border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
		self.addSubview(border)
    }
    
    func addBottomBorder(withColor color: UIColor, andWidth width: CGFloat) {
        let border = UIView()
		border.tag = 1003
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        self.addSubview(border)
    }
    
    func addLeftBorder(withColor color: UIColor, andWidth width: CGFloat) {
		let border = UIView()
		border.tag = 1004
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
		self.addSubview(border)
    }
	
	func removeAllBorders() {
		for view in self.subviews {
			if view.tag >= 1001 && view.tag <= 1004 {
				view.removeFromSuperview()
			}
		}
	}
}

// MARK: Effects
extension UIView {
	static let blurEffectTag = -1
    
    func addBlurEffect(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        clipsToBounds = true
        
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.tag = UIView.blurEffectTag
        
        addSubview(blurEffectView)
        blurEffectView.fillSuperView()
    }
    
    func removeBlurEffect() {
        viewWithTag(UIView.blurEffectTag)?.removeFromSuperview()
    }
    
    func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 7
        layer.masksToBounds = false
    }
    
    func applyLightShadow() {
        layer.shadowColor = UIColor.lightShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 9
        layer.masksToBounds = false
    }
    
    func applyAccentColorGradient(size: CGSize, cornerRadius: CGFloat = 0, axis: NSLayoutConstraint.Axis = .horizontal) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = size
        
        gradientLayer.cornerRadius = cornerRadius
        
        let startColor = UIColor.accentGradientStart.cgColor
        let endColor = UIColor.accentGradientEnd.cgColor
        
        if axis == .horizontal {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        
        gradientLayer.colors = [startColor, endColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }
	
	func updateAccentColorGradient() {
		guard let sublayers = layer.sublayers else { return }
		
		for layer in sublayers {
			if let gradientLayer = layer as? CAGradientLayer {
				gradientLayer.colors = [UIColor.accentGradientStart.cgColor, UIColor.accentGradientEnd.cgColor]
			}
		}
	}
    
    func toggleGradientLayer(show: Bool? = nil) {
        for sublayer in layer.sublayers ?? [] {
            if let gradientLayer = sublayer as? CAGradientLayer {
                gradientLayer.isHidden = !(show ?? gradientLayer.isHidden)
            }
        }
    }
    
    func roundCorners(_ corners: [UIDirectionalRectCorner], withRadius radius: CGFloat? = nil) {
        if let radius = radius {
            layer.cornerRadius = radius
        }
        
        var caCornerMasks: CACornerMask = []
        
        for corner in corners {
            guard let noneDirectionalCorner = LayoutTools.mapUIDirectionalRectCornerToUIRectCorner(corner, forView: self),
                  let caCornerMask = LayoutTools.mapUIRectCornerToCACornerMask(noneDirectionalCorner) else { continue }
            caCornerMasks.insert(caCornerMask)
        }
        
        layer.maskedCorners = caCornerMasks
    }
    
    func roundCorner(_ corner: UIDirectionalRectCorner, withRadius radius: CGFloat? = nil) {
        roundCorners([corner], withRadius: radius)
    }
	
	func scale(to scale: CGFloat) {
		self.transform = CGAffineTransform(scaleX: scale, y: scale)
	}
}

// MARK: Animations and Transformations
extension UIView {
    func translateViewVertically(by translation: CGFloat) {
        self.frame.origin.y -= translation
    }
    
    func translateViewHorizontally(by translation: CGFloat) {
        self.frame.origin.x -= translation
    }
    
    func resetViewVerticalTranslation() {
        self.frame.origin.y = 0
    }
    
    func resetViewHorizontalTranslation() {
        self.frame.origin.x = 0
    }
    
    func mapUIHorizontalDirectionToDirectionalInt(_ direction: UIHorizontalDirection) -> Int {
        switch direction {
        case .leadingToTrailing:
            return LayoutTools.getCurrentLayoutDirection(for: self) == .leftToRight ? -1 : 1
        case .trailingToLeading:
            return LayoutTools.getCurrentLayoutDirection(for: self) == .leftToRight ? 1 : -1
        }
    }
    
    /// Animates two consecutive animations while executing the `midAnimationCompletionHandler` between the two animations.
    func animateTwoConsecutiveAnimations(withDuration duration: TimeInterval,
                                         firstAnimation: @escaping () -> Void,
                                         secondAnimation: @escaping () -> Void,
                                         midAnimationCompletionHandler: ( (_ : Bool) -> Void)? = nil,
                                         completionHandler: ( (_ : Bool) -> Void)? = nil) {
        
        func didCompleteFirstAnimation(completed : Bool) {
            midAnimationCompletionHandler?(completed)
            UIView.animate(withDuration: duration / 2, animations: secondAnimation, completion: completionHandler)
        }
        
        UIView.animate(withDuration: duration / 2, animations: firstAnimation, completion: didCompleteFirstAnimation)
    }
    
    /// Translates the view horizontally out of the bounds of its superview then translates it in from the other side to give the effect of page switching.
    func translateHorizontallyOutAndInSuperView(withDuration duration: TimeInterval,
                                                atDirection direction: UIHorizontalDirection,
                                                fadeOutAndIn: Bool = false,
                                                midAnimationCompletionHandler: ((_ : Bool) -> Void)? = nil,
                                                completionHandler: ((_ : Bool) -> Void)? = nil) {
        
        let translationDirection = CGFloat(mapUIHorizontalDirectionToDirectionalInt(direction))
        
        func translateAndToggleAlpha() {
            translateViewHorizontally(by: translationDirection * LayoutConstants.screenWidth)
            if fadeOutAndIn {
                alpha = alpha == 0.5 ? 1 : 0.5
            }
        }
        
        func didCompleteFirstAnimation(completed : Bool) {
            midAnimationCompletionHandler?(completed)
            translateViewHorizontally(by: translationDirection * LayoutConstants.screenWidth * -2)
        }
        
        animateTwoConsecutiveAnimations(
            withDuration: duration,
            firstAnimation: translateAndToggleAlpha,
            secondAnimation: translateAndToggleAlpha,
            midAnimationCompletionHandler: didCompleteFirstAnimation,
            completionHandler: completionHandler)
    }
    
    /// fades the view out then fades it back in.
    func fadeOutAndIn(withDuration duration: TimeInterval, midAnimationCompletionHandler: ( (_ : Bool) -> Void)? = nil, completionHandler: ((_ : Bool) -> Void)? = nil) {
        alpha = 1
        
        func toggleAlpha() {
            alpha = alpha == 1 ? 0 : 1
        }
        
        animateTwoConsecutiveAnimations(
            withDuration: duration,
            firstAnimation: toggleAlpha,
            secondAnimation: toggleAlpha,
            midAnimationCompletionHandler: midAnimationCompletionHandler,
            completionHandler: completionHandler)
    }
    
}

// MARK: Tools
extension UIView {
    func roundAsCircle() {
        self.layer.cornerRadius = self.frame.height / 2;
        self.layer.masksToBounds = true
		self.clipsToBounds = true
    }
}

// MARK: Computed Proprieties
extension UIView {
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }	
}
