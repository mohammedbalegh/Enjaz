
import UIKit

class SelfEvaluationChart: UIView {
    
    let categories = ["المالي","الشخصي","المهني","الاجتماعي","الصحي","الثقافي","الديني"]
    
    let percentageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let categoriesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let slidersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupSlider()
        setupCategoriesStack()
        setupPercentageStack()
    }
    
    func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(7)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(text)"
        return label
    }
    
    func createSlider(with: Int) -> ChartSliderView {
        let slider = ChartSliderView(frame: .zero, category: categories[with - 1])
        slider.setValue(UserDefaults.standard.float(forKey: "\(categories[with - 1])"), animated: true)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }
    
    func setupSlider() {
        addSubview(slidersStackView)
        
        for index in 1...7 {
            let slider = createSlider(with: index)
            slider.tintColor = .accentColor
            slidersStackView.addArrangedSubview(slider)
        }
        
        NSLayoutConstraint.activate([
            slidersStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            slidersStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -(LayoutConstants.screenHeight * 0.02)),
            slidersStackView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.785),
            slidersStackView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85)
        ])
    }
    
    func setupCategoriesStack() {
        addSubview(categoriesStack)
        
        for text in categories {
            let label = createLabel(text)
            categoriesStack.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            categoriesStack.widthAnchor.constraint(equalTo: slidersStackView.heightAnchor),
            categoriesStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            categoriesStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            categoriesStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
        ])
        
        layoutIfNeeded()
        
        categoriesStack.addTopBorderWithColor(color: .lightGray, width: 1)
    }
    
    func setupPercentageStack() {
        addSubview(percentageStack)

        
        for percentage in stride(from: 100, to: -10, by: -10) {
            let label = createLabel("\(percentage)%")
            percentageStack.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            percentageStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            percentageStack.topAnchor.constraint(equalTo: self.topAnchor),
            percentageStack.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.256),
            percentageStack.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.06),
        ])
        
        layoutIfNeeded()
        
        percentageStack.addRightBorderWithColor(color: .lightGray, width: 1)
    }
    
}
