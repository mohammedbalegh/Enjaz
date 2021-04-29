import UIKit

class PrimaryBtn: UIButton {
    enum BtnTheme {
        case blue, white
    }
	
	enum BtnSize {
		case small, large
	}
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.isHidden = true
        
        return indicator
    }()
    
    var label = ""
    var theme: BtnTheme = .blue
	var size: BtnSize = .small
    var isLoading = false {
        didSet {
            isEnabled = !isLoading
            activityIndicator.isHidden = !isLoading
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
	init(label: String, theme: BtnTheme, size: BtnSize? = nil) {
        super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
        self.label = label
        self.theme = theme
		if let size = size {
			self.size = size
		}
    }
    
    convenience init(theme: BtnTheme, size: BtnSize? = nil) {
        self.init(label: "", theme: theme, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func didMoveToWindow() {
		guard window != nil else { return }
		
        setup()
        setupActivityIndicator()
	}
    
    func setup() {
        var btnWidth, btnHeight, fontSize : CGFloat
        
        if size == .large {
            fontSize = max(22, LayoutConstants.screenHeight * 0.025)
            btnHeight = LayoutConstants.screenHeight * 0.053
            btnWidth = LayoutConstants.screenWidth * 0.7
        } else {
            fontSize = max(16, LayoutConstants.screenHeight * 0.02)
            btnHeight = LayoutConstants.screenHeight * 0.05
            btnWidth = LayoutConstants.screenWidth * 0.57
        }
        
        titleLabel?.font = .systemFont(ofSize: fontSize)
        
        if !label.isEmpty {
            setTitle(label, for: .normal)
        }
        
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.cornerRadius = btnHeight / 2
        
        if theme == .blue {
            applyAccentColorGradient(size: CGSize(width: btnWidth, height: btnHeight), cornerRadius: layer.cornerRadius)
            activityIndicator.color = .white
            setTitleColor(.white, for: .normal)
            layer.shadowColor = UIColor.accent.cgColor
        } else {
            backgroundColor = .white
            activityIndicator.color = .accent
            setTitleColor( .gray, for: .normal)
            layer.shadowColor = UIColor.gray.cgColor
        }
        
        let highlightedTitleColor = titleColor(for: .normal)?.withAlphaComponent(0.3)
        setTitleColor(highlightedTitleColor, for: .highlighted)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: btnHeight),
            widthAnchor.constraint(equalToConstant: btnWidth),
        ])
    }
    
    func setupActivityIndicator() {
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            activityIndicator.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -layer.cornerRadius * 0.5 - 10),
        ])
    }
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		if theme == .blue {
			updateAccentColorGradient()
		}
	}
}
