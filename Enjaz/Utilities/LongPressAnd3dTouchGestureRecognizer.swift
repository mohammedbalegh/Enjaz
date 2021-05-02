import UIKit

/// A Gesture Recognizer that fires either on long press, or on "3D Touch"
final class LongPressAnd3dTouchGestureRecognizer: UILongPressGestureRecognizer {
	
	// MARK: - Properties
	var triggerWithForceTouch: Bool = true
	
	// MARK: - UIGestureRecognizer
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		self.handleTouches(touches, with: event)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesMoved(touches, with: event)
		self.handleTouches(touches, with: event)
	}
}

private extension LongPressAnd3dTouchGestureRecognizer {
	
	func handleTouches(_ touches: Set<UITouch>, with event: UIEvent) {
		guard self.triggerWithForceTouch else { return }
		guard self.state == .possible else { return }
		guard let traitCollection = self.view?.traitCollection else { return }
		guard traitCollection.forceTouchCapability == .available else { return }
		guard touches.count == 1 else { return }
		
		let touch = touches.first!
		let force = touch.force / touch.maximumPossibleForce
		
		if force >= 1.0 {
			self.state = .began
		}
	}
}
