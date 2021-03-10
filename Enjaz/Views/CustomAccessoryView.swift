import UIKit

class CustomAccessoryView: UIView {
    
    let doneBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        button.setTitleColor(.accentColor, for: .normal)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.systemGray5.withAlphaComponent(0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupDoneBtn()
    }
    
    func setupDoneBtn() {
        addSubview(doneBtn)
        
        NSLayoutConstraint.activate([
            doneBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            doneBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            doneBtn.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            doneBtn.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
        ])
    }
    
}
