import UIKit

class PrimaryBtn: UIButton {
    
    enum btnThemeType {
        case blue
        case white
    }
    
    var label = ""
    var theme: btnThemeType = .blue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(label: String, theme: btnThemeType) {
        super.init(frame: .zero)
        self.label = label
        self.theme = theme
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        if theme == .blue {
            self.backgroundColor = Colors.mainBTNColor
            self.setTitleColor(.white, for: .normal)
            self.layer.shadowColor = Colors.mainBTNColor?.cgColor
        } else {
            self.backgroundColor = .white
            self.setTitleColor( .gray, for: .normal)
            self.layer.shadowColor = UIColor.gray.cgColor
        }
        
        self.setTitle(label, for: .normal)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)

        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
