import UIKit

class TitledInputFieldContainer: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 18)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let inputFieldContainer = InputFieldContainer()
    
    var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            inputFieldContainer.fieldName = newValue ?? ""
        }
    }
    
    var input: (UIView & InputField)? {
        get { inputFieldContainer.input }
        set {
            setupSubViews()
            inputFieldContainer.input = newValue
        }
    }
    
    init(input: (UIView & InputField)?, title: String?) {
        super.init(frame: .zero)
        self.input = input
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupTitleLabel()
        setupInputFieldContainer()
    }
        
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    func setupInputFieldContainer() {
        addSubview(inputFieldContainer)
        inputFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputFieldContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            inputFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputFieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
