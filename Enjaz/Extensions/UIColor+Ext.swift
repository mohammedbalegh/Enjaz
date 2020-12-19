import UIKit

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
		assertRGBComponentsRange(red, green, blue, alpha)
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
	}
	
	convenience init(hex: Int) {
		if(hex == 0xfff) {
			self.init(red: 255, green: 255, blue: 255)
			return
		}
		
		self.init(
			red: (hex >> 16) & 0xFF,
			green: (hex >> 8) & 0xFF,
			blue: hex & 0xFF
		)
	}
	
	static let accentColor = UIColor(hex: 0x12B3B9)
	static let rootTabBarScreensBackgroundColor = UIColor(hex: 0xF9F9F9)
}

func assertRGBComponentsRange(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) {
	assert(red >= 0 && red <= 255, "Invalid value specified for the red component, must be between 0 and 255")
	assert(green >= 0 && green <= 255, "Invalid value specified for the green component, must be between 0 and 255")
	assert(blue >= 0 && blue <= 255, "Invalid value specified for the blue component, must be between 0 and 255")
	assert(alpha >= 0 && alpha <= 1, "Invalid value specified for the alpha component, must be between 0 and 1")
}
