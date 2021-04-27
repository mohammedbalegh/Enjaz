import UIKit

class DailyViewTableViewCustomHeader: UITableViewHeaderFooterView {
    
    let dayNumberLabel: UILabel = {
        let label = UILabel()
        let format = NumberFormatter()
        label.font = label.font.withSize(20)
        label.textColor = .systemGray
        return label
    }()
    
    let weekDayNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(17.5)
        label.textColor = .systemGray2
        return label
    }()
    
    lazy var dayLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayNumberLabel, weekDayNameLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    let numberOfItemsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(11)
        label.textColor = .systemGray2
        return label
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayLabelsStackView, numberOfItemsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .equalSpacing
        stackView.alignment = .bottom
        
        return stackView
    }()
    	
	override var frame: CGRect {
		didSet {
			addBottomBorder(withColor: .border, andWidth: 0.5)
		}
	}
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupLabelStackView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabelStackView() {
        contentView.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelsStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            labelsStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
        ])
    }
    
}
