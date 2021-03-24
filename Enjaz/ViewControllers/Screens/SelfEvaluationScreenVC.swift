
import UIKit

class SelfEvaluationScreenVC: SelectableScreenVC {
    
    let whatYouLearnedLabel: SelfEvaluationLabel = {
        let label = SelfEvaluationLabel()
        label.label.text  = "ماذا تعلمت"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whatChangedLabel: SelfEvaluationLabel = {
        let label = SelfEvaluationLabel()
        label.label.text  = "ما الذي تغير فيك"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whatYouFeelLabel: SelfEvaluationLabel = {
        let label = SelfEvaluationLabel()
        label.label.text  = "ما هي مشاعرك"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let goalsTextField: EditableTextView = {
        let textField = EditableTextView(frame: .zero)
        textField.placeholder = "أكتب ما تريد تحقيقه من اهداف هنا"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let selfEvaluationChart: SelfEvaluationChart = {
        let chart = SelfEvaluationChart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        navigationController?.title = "تقيم النفس"
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        title = "تقييم النفس"
        
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupWhatYouLearnedLabel()
        setupWhatChangedLabel()
        setupWhatYouFeelLabel()
        setupGoalsTextField()
        setupSelfEvaluationChart()
    }
    
    func setupWhatYouLearnedLabel() {
        view.addSubview(whatYouLearnedLabel)
        
        NSLayoutConstraint.activate([
            whatYouLearnedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            whatYouLearnedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            whatYouLearnedLabel.heightAnchor.constraint(equalToConstant: 15),
            whatYouLearnedLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.24)
        ])
    }
    
    func setupWhatChangedLabel() {
        view.addSubview(whatChangedLabel)
        
        NSLayoutConstraint.activate([
            whatChangedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            whatChangedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            whatChangedLabel.heightAnchor.constraint(equalToConstant: 15),
            whatChangedLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.27)
        ])
    }
    
    func setupWhatYouFeelLabel() {
        view.addSubview(whatYouFeelLabel)
        
        NSLayoutConstraint.activate([
            whatYouFeelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            whatYouFeelLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            whatYouFeelLabel.heightAnchor.constraint(equalToConstant: 15),
            whatYouFeelLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.24)
        ])
    }
    
    func setupGoalsTextField() {
        view.addSubview(goalsTextField)
        
        goalsTextField.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            goalsTextField.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.889),
            goalsTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.238),
            goalsTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goalsTextField.topAnchor.constraint(equalTo: whatChangedLabel.bottomAnchor, constant: 20)
        ])
    }
    
    func setupSelfEvaluationChart() {
        view.addSubview(selfEvaluationChart)
        
        NSLayoutConstraint.activate([
            selfEvaluationChart.topAnchor.constraint(equalTo: goalsTextField.bottomAnchor, constant: 20),
            selfEvaluationChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selfEvaluationChart.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.9),
            selfEvaluationChart.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.3)
        ])
    }

}
