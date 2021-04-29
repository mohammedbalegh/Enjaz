import UIKit

class CustomAccessoryView: UIView {
    
    let doneBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        button.setTitleColor(.accent, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGray5.withAlphaComponent(0.6)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
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
