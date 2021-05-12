import UIKit

class AlertPopupAction: UIButton {
	enum Style {
		case normal, destructive
	}
	
	let separator = UIView()
	
	var title: String?
	var style: Style
	var handler: (() -> Void)?
	
	var isLastAction: Bool = false {
		didSet {
			separator.isHidden = isLastAction
		}
	}
	
	init(title: String?, style: Style, handler: (() -> Void)? = nil) {
		self.title = title
		self.style = style
		self.handler = handler
		
		super.init(frame: .zero)
		
		setTitle(title, for: .normal)
		
		let titleColor: UIColor = style == .normal ? .highContrastText : .systemRed
		setTitleColor(titleColor, for: .normal)
		setTitleColor(titleColor.withAlphaComponent(0.3), for: .highlighted)
		
		titleLabel?.font = .systemFont(ofSize: 15)
		
		addTarget(self, action: #selector(handleTap), for: .touchUpInside)
		
		setupSeparator()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSeparator() {
		addSubview(separator)
		separator.translatesAutoresizingMaskIntoConstraints = false
		separator.backgroundColor = .lowContrastGray
		
		NSLayoutConstraint.activate([
			separator.centerYAnchor.constraint(equalTo: centerYAnchor),
			separator.trailingAnchor.constraint(equalTo: trailingAnchor),
			separator.widthAnchor.constraint(equalToConstant: 1),
			separator.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
		])
	}
	
	@objc func handleTap() {
		handler?()
	}
}
