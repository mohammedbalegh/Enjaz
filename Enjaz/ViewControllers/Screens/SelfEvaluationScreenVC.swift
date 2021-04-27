
import UIKit

class SelfEvaluationScreenVC: UIViewController {
    
    let defaults = UserDefaults.standard
    var categoryId: Int = 0
    
    var submitChangesButton: UIButton = {
        var button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named:"checkButton"), for: .normal)
        button.addTarget(self, action: #selector(submitNoteChanges), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let whatYouLearnedLabel: SelfEvaluationLabel = {
        let label = SelfEvaluationLabel()
        label.label.text  = NSLocalizedString("What have you learned", comment: "")
        label.label.font = .systemFont(ofSize: 12)
        label.label.adjustsFontSizeToFitWidth = true
        label.label.minimumScaleFactor = 0.3
        label.label.lineBreakMode = .byWordWrapping
        label.label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whatChangedLabel: SelfEvaluationLabel = {
        let label = SelfEvaluationLabel()
        label.label.text  = NSLocalizedString("What changed in you", comment: "")
        label.label.font = .systemFont(ofSize: 12)
        label.label.adjustsFontSizeToFitWidth = true
        label.label.minimumScaleFactor = 0.5
        label.label.lineBreakMode = .byWordWrapping
        label.label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whatYouFeelLabel: SelfEvaluationLabel = {
        let label = SelfEvaluationLabel()
        label.label.text  = NSLocalizedString("How do you feel", comment: "")
        label.label.font = .systemFont(ofSize: 12)
        label.label.adjustsFontSizeToFitWidth = true
        label.label.minimumScaleFactor = 0.5
        label.label.lineBreakMode = .byWordWrapping
        label.label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let goalTextField: EditableTextView = {
        let textField = EditableTextView(frame: .zero)
        textField.placeholder = "أكتب ما تريد تحقيقه من اهداف هنا"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lowContrastGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
	
    let selfEvaluationChart: SelfEvaluationChart = {
        let chart = SelfEvaluationChart()
        chart.layer.cornerRadius = 15
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        title = NSLocalizedString("Self Evaluation", comment: "")
        
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goalTextField.text = defaults.string(forKey: "GoalTextFieldOfCategory\(categoryId)")
        goalTextField.textColor = .highContrastText
        selfEvaluationChart.slider.value = defaults.float(forKey: "SliderValueOfCategory\(categoryId)")
    }
    
    func setupSubviews() {
        setupWhatYouLearnedLabel()
        setupWhatChangedLabel()
        setupWhatYouFeelLabel()
        setupGoalsTextField()
        setupSelfEvaluationChart()
        setupSubmitNoteChanges()
    }
    
    @objc func submitNoteChanges() {
        defaults.set(goalTextField.text, forKey: "GoalTextFieldOfCategory\(categoryId)")
        defaults.set(selfEvaluationChart.slider.value, forKey: "SliderValueOfCategory\(categoryId)")
        navigationController?.popViewController(animated: true)
    }
    
    func setupSubmitNoteChanges() {
        view.addSubview(submitChangesButton)
        
        let size = LayoutConstants.screenWidth * 0.151
        
        NSLayoutConstraint.activate([
            submitChangesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.06)),
            submitChangesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitChangesButton.widthAnchor.constraint(equalToConstant: size),
            submitChangesButton.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupWhatYouLearnedLabel() {
        view.addSubview(whatYouLearnedLabel)
        
        NSLayoutConstraint.activate([
            whatYouLearnedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            whatYouLearnedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            whatYouLearnedLabel.heightAnchor.constraint(equalToConstant: 35),
            whatYouLearnedLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.24)
        ])
    }
    
    func setupWhatChangedLabel() {
        view.addSubview(whatChangedLabel)
        
        NSLayoutConstraint.activate([
            whatChangedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            whatChangedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            whatChangedLabel.heightAnchor.constraint(equalToConstant: 35),
            whatChangedLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.27)
        ])
    }
    
    func setupWhatYouFeelLabel() {
        view.addSubview(whatYouFeelLabel)
        
        NSLayoutConstraint.activate([
            whatYouFeelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            whatYouFeelLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            whatYouFeelLabel.heightAnchor.constraint(equalToConstant: 35),
            whatYouFeelLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.24)
        ])
    }
    
    func setupGoalsTextField() {
        view.addSubview(goalTextField)
        
        goalTextField.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            goalTextField.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.889),
            goalTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.238),
            goalTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goalTextField.topAnchor.constraint(equalTo: whatChangedLabel.bottomAnchor, constant: 20)
        ])
    }
    
    func setupSelfEvaluationChart() {
        view.addSubview(selfEvaluationChart)
            
        NSLayoutConstraint.activate([
            selfEvaluationChart.topAnchor.constraint(equalTo: goalTextField.bottomAnchor, constant: 20),
            selfEvaluationChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selfEvaluationChart.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.9),
            selfEvaluationChart.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.15)
        ])
    }
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		goalTextField.layer.borderColor = UIColor.lowContrastGray.cgColor
	}

}
