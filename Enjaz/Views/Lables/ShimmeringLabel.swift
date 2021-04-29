import UIKit
import ShimmerSwift

class ShimmeringLabel: UILabel {
	
	var shimmeringView: ShimmeringView = {
		let contentView = UIView()
		contentView.backgroundColor = .lowContrastGray
		contentView.layer.cornerRadius = 2
		
		
		let view = ShimmeringView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.shimmerSpeed = 0.1
		view.shimmerPauseDuration = 0.8
		view.isShimmering = true
		view.contentView = contentView
		
		return view
	}()
		
	override var text: String? {
		didSet {
			if let text = text, !text.isEmpty {
				shimmeringView.isShimmering = false
				shimmeringView.removeFromSuperview()
			}
		}
	}
	
	init() {
		super.init(frame: .zero)
		addSubview(shimmeringView)
		NSLayoutConstraint.activate([
			shimmeringView.topAnchor.constraint(equalTo: topAnchor),
			shimmeringView.leadingAnchor.constraint(equalTo: leadingAnchor),
			shimmeringView.trailingAnchor.constraint(equalTo: trailingAnchor),
			shimmeringView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
}
