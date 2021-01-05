import UIKit

class AppLogo: UIImageView {
	init() {
        super.init(frame: .zero)
		image = UIImage(named: "logo")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
