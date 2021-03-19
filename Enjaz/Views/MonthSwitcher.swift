import UIKit

class MonthSwitcher: UIStackView {

    let previousMonthBtn: UIButton = {
        let arrowIcon = UIImage(systemName: "chevron.backward")
        let button = UIButton(type: .system)
        
        button.frame.size = CGSize(width: 30, height: 30)
        button.setImage(arrowIcon, for: .normal)
        button.tintColor = .accentColor
        
        return button
    }()
    
    let nextMonthBtn: UIButton = {
        let arrowIcon = UIImage(systemName: "chevron.forward")
        let button = UIButton(type: .system)
        
        button.setImage(arrowIcon, for: .normal)
        button.tintColor = .accentColor
        
        return button
    }()
    
    let selectedMonthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        return label
    }()
    
    lazy var monthSwitcherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousMonthBtn, selectedMonthLabel, nextMonthBtn])
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        return stackView
    }()
    
    let selectedYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .center
        addArrangedSubview(monthSwitcherStackView)
        addArrangedSubview(selectedYearLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
