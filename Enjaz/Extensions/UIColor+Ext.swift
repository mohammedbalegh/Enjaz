import UIKit

extension UIColor {
    var inverted: UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: (1 - red), green: (1 - green), blue: (1 - blue), alpha: alpha)
    }
    
	convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
		assertRGBComponentsRange(red, green, blue, alpha)
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
	}
	
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
		if hex == 0xfff {
            self.init(red: 255, green: 255, blue: 255, alpha: alpha)
			return
		}
		
		self.init(
			red: (hex >> 16) & 0xFF,
			green: (hex >> 8) & 0xFF,
			blue: hex & 0xFF,
            alpha: alpha)
	}
    
	static let accentColor = UIColor(hex: 0x12B3B9)
	static let mainScreenBackgroundColor = UIColor(hex: 0xF9F9F9)
	static let gradientStartColor = UIColor(hex: 0x20D4D0)
	static let gradientEndColor = UIColor(hex: 0x12B3B9)
    static let borderColor = UIColor(white: 0.85, alpha: 1)
    static let indicatorColor = UIColor(hex: 0xFFD400)
    
}

func assertRGBComponentsRange(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) {
	assert(red >= 0 && red <= 255, "Invalid value specified for the red component, must be between 0 and 255")
	assert(green >= 0 && green <= 255, "Invalid value specified for the green component, must be between 0 and 255")
	assert(blue >= 0 && blue <= 255, "Invalid value specified for the blue component, must be between 0 and 255")
	assert(alpha >= 0 && alpha <= 1, "Invalid value specified for the alpha component, must be between 0 and 1")
}
