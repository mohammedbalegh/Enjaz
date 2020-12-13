import UIKit

class PrimaryBtn: UIButton {
    enum BtnTheme {
        case blue, white
    }
	
	enum BtnSize {
		case small, large
	}
    
    var label = ""
    var theme: BtnTheme = .blue
	var size: BtnSize = .small
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
	init(label: String, theme: BtnTheme, size: BtnSize? = nil) {
        super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
        self.label = label
        self.theme = theme
		if let size = size {
			self.size = size
		}
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func didMoveToWindow() {
		guard window != nil else { return }
		
		let largeBtnHeight = LayoutConstants.screenHeight * 0.06
		let smallBtnHeight = LayoutConstants.screenHeight * 0.053
		let btnHeight = size == .large ? largeBtnHeight : smallBtnHeight
		
		layer.cornerRadius = btnHeight / 2
		heightAnchor.constraint(equalToConstant: btnHeight).isActive = true
	}
    
    func setup() {
        if theme == .blue {
			backgroundColor = .accentColor
            setTitleColor(.white, for: .normal)
			layer.shadowColor = UIColor.accentColor.cgColor
        } else {
            backgroundColor = .white
            setTitleColor( .gray, for: .normal)
            layer.shadowColor = UIColor.gray.cgColor
        }
        
		let largeBtnFontSize = max(22, LayoutConstants.screenHeight * 0.03)
		let smallBtnFontSize = max(16, LayoutConstants.screenHeight * 0.02)
		let fontSize = size == .large ? largeBtnFontSize : smallBtnFontSize
		titleLabel?.font = .systemFont(ofSize: fontSize)
        setTitle(label, for: .normal)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0, height: 5)
		
        translatesAutoresizingMaskIntoConstraints = false
    }
}
