
import UIKit

class OneTimeCodeTextField: UITextField {
    
    var didEnterLastCharacter: ((String) -> Void)?
    
    private var isConfigured = false
    
    private var digitLabels: [UILabel] = []
    
    lazy var labelsStackView = createLabelStackView(with: 6)
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()

    func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        setupLabelsStackView()    
    }
    
    func setupLabelsStackView() {
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    
    func configureTextField() {
        tintColor = .clear
        textColor = .clear
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        delegate = self
    }
    
    private func createLabelStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1...count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 30)
            label.backgroundColor = .white
            label.textColor = .gray
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.accentColor.cgColor
            label.applyShadow()
            
            DispatchQueue.main.async {
                label.layer.cornerRadius = 12
                label.clipsToBounds = true
            }
            
            
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        stackView.semanticContentAttribute = .forceLeftToRight
        return stackView
    }
    
    @objc func textDidChange() {
        
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text?.removeAll()
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastCharacter?(text)
        }
    }
}

extension OneTimeCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return  characterCount < digitLabels.count || string  == ""
    }
}
