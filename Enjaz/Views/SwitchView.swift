import UIKit

class SwitchView: UIStackView {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = .systemGray2
        return label
    }()
    
    let `switch` = UISwitch()
    
    lazy var switchLabelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, `switch`])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addArrangedSubview(switchLabelStack)
        addArrangedSubview(descriptionLabel)
        axis = .vertical
        distribution = .fillEqually
        alignment = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
