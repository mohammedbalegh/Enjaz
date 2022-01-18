import UIKit

class WeekDayLabelsStackView: UIStackView {
    
    lazy var weekDayNamesStackView: UIStackView = {
        let nameLabels = generateWeekDayNameLabels()
        let stackView = UIStackView(arrangedSubviews: nameLabels)
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var weekDayNumbersStackView: UIStackView = {
        let numberLabels = generateWeekDayNumberLabels()
        let stackView = UIStackView(arrangedSubviews: numberLabels)
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addArrangedSubview(weekDayNamesStackView)
        
        axis = .vertical
        distribution = .fillEqually
        alignment = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func generateWeekDayNameLabels() -> [UILabel] {
        var labels: [UILabel] = []
        
        let formatter = DateFormatter()
        let weekDayNames = formatter.shortWeekdaySymbols ?? []
        
        for weekDayName in weekDayNames {
            let weekDayLabel = UILabel(frame: .zero)
            
            weekDayLabel.text = weekDayName
            weekDayLabel.textColor = .white
            weekDayLabel.font = .systemFont(ofSize: 13)
            weekDayLabel.textAlignment = .center
            
            labels.append(weekDayLabel)
        }
        
        return labels
    }
    
    func generateWeekDayNumberLabels() -> [UILabel] {
        var labels: [UILabel] = []
        
        for _ in 0...6 {
            let weekDayLabel = UILabel(frame: .zero)
            
            weekDayLabel.textColor = .lowContrastGray
            weekDayLabel.font = .systemFont(ofSize: 17)
            weekDayLabel.textAlignment = .center
            
            labels.append(weekDayLabel)
        }
        
        return labels
    }
        
    func updateWeekDayNumbers(with weekDayNumbers: [String]) {
        resetWeekDayNumbers()
        
        for i in 0...weekDayNumbers.count - 1 {
            let label = weekDayNumbersStackView.arrangedSubviews[i] as! UILabel
            label.text = weekDayNumbers[i]
        }
    }
    
    func resetWeekDayNumbers() {
        weekDayNumbersStackView.arrangedSubviews.forEach { ($0 as! UILabel).text = "" }
    }
        
    func showWeekDayNumbers() {
        addArrangedSubview(weekDayNumbersStackView)
        toggleGradientLayer(show: false)
        setWeekNameLabelsTextColor(.systemGray)
    }
    
    func hideWeekDayNumbers() {
        removeArrangedSubview(weekDayNumbersStackView)
        weekDayNumbersStackView.removeFromSuperview()
        toggleGradientLayer(show: true)
        setWeekNameLabelsTextColor(.white)
    }
    
    func setWeekNameLabelsTextColor(_ color: UIColor) {
        for i in 0...6 {
            let label = weekDayNamesStackView.arrangedSubviews[i] as! UILabel
            label.textColor = color
        }
    }
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		updateAccentColorGradient()
	}
}
