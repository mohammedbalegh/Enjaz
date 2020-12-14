import UIKit

class AppLogo: UIImageView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		image = UIImage(named: "logo")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
