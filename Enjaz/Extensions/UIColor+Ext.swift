import UIKit

extension UIColor {
	static let accent = UIColor(hex: 0x12B3B9)
	static let background = UIColor(hex: 0xF9F9F9) | .black
	static let secondaryBackground = .white | UIColor(red: 28, green: 28, blue: 30)
	static let tertiaryBackground = .white | UIColor(red: 14, green: 14, blue: 15)
	static let modalScreenBackground = .white | UIColor(red: 12, green: 12, blue: 16)
	static let invertedSystemBackground = .black | .white
	static let highContrastGray = .darkGray | .lightGray
	static let lowContrastGray = .lightGray | .darkGray
	static let highContrastText = .darkText | .lightText
	static let accentGradientStart = UIColor(hex: 0x20D4D0) | UIColor(hex: 0x1FC1BD)
	static let accentGradientEnd = UIColor(hex: 0x12B3B9) | UIColor(hex: 0x0F969B)
	static let border = UIColor(white: 0.9, alpha: 1) | UIColor(white: 0.9, alpha: 1).inverted
	static let indicator = UIColor(hex: 0xFFD400)
	static let lightShadow = UIColor(hex: 0x979797) | UIColor(hex: 0x979797).inverted
	
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
	
	static func | (lightModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
		return UIColor { (traitCollection) -> UIColor in
			return traitCollection.userInterfaceStyle == .light ? lightModeColor : darkModeColor
		}
	}
}

private func assertRGBComponentsRange(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) {
	assert(red >= 0 && red <= 255, "Invalid value specified for the red component, must be between 0 and 255")
	assert(green >= 0 && green <= 255, "Invalid value specified for the green component, must be between 0 and 255")
	assert(blue >= 0 && blue <= 255, "Invalid value specified for the blue component, must be between 0 and 255")
	assert(alpha >= 0 && alpha <= 1, "Invalid value specified for the alpha component, must be between 0 and 1")
}
