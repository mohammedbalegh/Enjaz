import UIKit

func forceLayoutDirectionTo(_ direction: UIUserInterfaceLayoutDirection) {
	UIView.appearance().semanticContentAttribute = direction == .leftToRight ? .forceLeftToRight : .forceRightToLeft
}

func getCurrentLayoutDirectionFor(_ view: UIView) -> UIUserInterfaceLayoutDirection {
	let attribute = view.semanticContentAttribute
	let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
	return layoutDirection
}
