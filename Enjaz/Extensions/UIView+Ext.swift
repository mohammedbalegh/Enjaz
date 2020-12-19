import UIKit

// MARK: Constraints
extension UIView {
	func throwNoSuperviewError() {
		fatalError("Attempting to set constraints to a \(type(of: self)) before adding it to a superView")
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
		
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: superview.topAnchor),
			leftAnchor.constraint(equalTo: superview.leftAnchor),
			bottomAnchor.constraint(equalTo: superview.bottomAnchor),
			rightAnchor.constraint(equalTo: superview.rightAnchor),
		])
	}
	
	/// make `self` fill the specified `view` with specified margins.
	func fill(_ view: UIView, top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0) {
		disableAutoresizingMaskTranslationIfEnabled()

		NSLayoutConstraint.activate([
			leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
			rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
			topAnchor.constraint(equalTo: view.topAnchor, constant: top),
			bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
		])
	}
	
	/// Constrain 4 edges of `self` to specified `view`.
	func constrainEdgesToCorrespondingEdges(of view: UIView, top: CGFloat?=nil, leading: CGFloat?=nil, bottom: CGFloat?=nil, trailing: CGFloat?=nil) {
		disableAutoresizingMaskTranslationIfEnabled()
		
		var constraints: [NSLayoutConstraint] = []

		if let top = top { constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: top)) }
		if let leading = leading { constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading)) }
		if let bottom = bottom { constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)) }
		if let trailing = trailing {
			constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing))
		}
		

		NSLayoutConstraint.activate(constraints)
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
	
	func center(relativeTo view:UIView, centerX: Bool=false, centerY: Bool=false) {
		disableAutoresizingMaskTranslationIfEnabled()
		
		var constraints: [NSLayoutConstraint] = []
		
		if centerX { constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor)) }
		if centerY { constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor)) }
			
		NSLayoutConstraint.activate(constraints)
	}
	
	func constrainToSuperviewCorner(cornerPosition: UIRectCorner) {
		guard let superview = superview else {
			throwNoSuperviewError()
			return
		}
		disableAutoresizingMaskTranslationIfEnabled()
		
		let cornerRadius = superview.layer.cornerRadius
		
		let cornerRadiusInset = cornerRadius / 4
		
		if cornerPosition == .topLeft {
			NSLayoutConstraint.activate([
				centerYAnchor.constraint(equalTo: superview.topAnchor, constant: cornerRadiusInset),
				centerXAnchor.constraint(equalTo: superview.leftAnchor, constant: cornerRadiusInset),
			])
		} else if cornerPosition == .bottomLeft {
			NSLayoutConstraint.activate([
				centerXAnchor.constraint(equalTo: superview.leftAnchor, constant: cornerRadiusInset),
				centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: -cornerRadiusInset),
			])
		} else if cornerPosition == .bottomRight {
			NSLayoutConstraint.activate([
				centerXAnchor.constraint(equalTo: superview.rightAnchor, constant: -cornerRadiusInset),
				centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: -cornerRadiusInset),
			])
		} else if cornerPosition == .topRight {
			NSLayoutConstraint.activate([
				centerYAnchor.constraint(equalTo: superview.topAnchor, constant: cornerRadiusInset),
				centerXAnchor.constraint(equalTo: superview.rightAnchor, constant: -cornerRadiusInset),
			])
		}
	}
	
	private func disableAutoresizingMaskTranslationIfEnabled() {
		if translatesAutoresizingMaskIntoConstraints {
			translatesAutoresizingMaskIntoConstraints = false
		}
	}
	
	func addTopBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
		layer.addSublayer(border)
	}
	
	func addRightBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
		layer.addSublayer(border)
	}
	
	func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
		layer.addSublayer(border)
	}
	
	func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
		layer.addSublayer(border)
	}
}

// MARK: Effects
extension UIView {
	func blurView(style: UIBlurEffect.Style) {
		let blurEffect = UIBlurEffect(style: style)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.isUserInteractionEnabled = false
		blurEffectView.frame = bounds
		addSubview(blurEffectView)
	}
	
	func removeBlur() {
		for view in subviews {
			if let view = view as? UIVisualEffectView {
				view.removeFromSuperview()
			}
		}
	}
	
	func applyShadow() {
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowOpacity = 0.6
		layer.shadowRadius = 7
		layer.masksToBounds = false
	}
	
	func applyLightShadow() {
		layer.shadowColor = UIColor(hex: 0x979797).cgColor
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowOpacity = 0.2
		layer.shadowRadius = 9
		layer.masksToBounds = false
	}
}

// MARK: Animations
extension UIView {
	func animate(opacityTo alpha: CGFloat, andScaleTo scale: CGFloat) {
		self.alpha = alpha
		self.transform = CGAffineTransform(scaleX: scale, y: scale)
	}
}

extension UIView {
    func asCircle() {
        DispatchQueue.main.async{
            self.layer.cornerRadius = self.frame.width / 2;
            self.layer.masksToBounds = true         
        }
    }
}

