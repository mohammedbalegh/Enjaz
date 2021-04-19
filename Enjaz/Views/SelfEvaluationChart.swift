
import UIKit

class SelfEvaluationChart: UIView {
    
    let categories = ["0%","25%","50%","75%","100%",]
    
    let rateYourSelfLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = NSLocalizedString("Rate your progress in this field", comment: "")
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let percentageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.value = 0
        slider.isContinuous = true
        slider.isUserInteractionEnabled = true
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.maximumTrackTintColor = UIColor(hex: 0x707070)
        slider.minimumTrackTintColor = UIColor.accentColor
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.shadowRadius = 4
        layer.shadowColor = UIColor(hex: 0xD6D6D6).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupRateYourSelfLabel()
        setupPercentageStack()
        setupSlider()
    }
    
    @objc func sliderValueChanged() {
        print(slider.value)
    }
    
    func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(text)"
        return label
    }
    
    func setupRateYourSelfLabel() {
        addSubview(rateYourSelfLabel)
        
        NSLayoutConstraint.activate([
            rateYourSelfLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            rateYourSelfLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            rateYourSelfLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            rateYourSelfLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    func setupSlider() {
        addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: percentageStack.topAnchor, constant: -30),
            slider.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.02),
            slider.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.8),
        ])
    }
    
    func setupPercentageStack() {
        addSubview(percentageStack)

        
        for percentage in categories {
            percentageStack.addArrangedSubview(createLabel(percentage))
        }
        
        NSLayoutConstraint.activate([
            percentageStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            percentageStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            percentageStack.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.02),
            percentageStack.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.8),
        ])
        
        layoutIfNeeded()
        
        percentageStack.addTopBorder(withColor: UIColor(hex: 0x707070), andWidth: 1)
    }
    
}
