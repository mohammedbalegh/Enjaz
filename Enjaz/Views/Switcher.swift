import UIKit

class Switcher: UIStackView {

    let previousBtn: UIButton = {
        let arrowIcon = UIImage(systemName: "chevron.backward")
        let button = UIButton(type: .system)
        
        button.setImage(arrowIcon, for: .normal)
        button.tintColor = .accent
        
        return button
    }()
    
    let nextBtn: UIButton = {
        let arrowIcon = UIImage(systemName: "chevron.forward")
        let button = UIButton(type: .system)
        
        button.setImage(arrowIcon, for: .normal)
        button.tintColor = .accent
        
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
		label.textColor = .highContrastText
        label.textAlignment = .center
        return label
    }()
    
    lazy var LabelAndBtnsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousBtn, label, nextBtn])
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        addArrangedSubview(LabelAndBtnsStackView)
        addArrangedSubview(secondaryLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
