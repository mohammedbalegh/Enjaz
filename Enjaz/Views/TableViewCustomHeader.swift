import UIKit

class TableViewCustomHeader: UITableViewHeaderFooterView {
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    
    let addBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.accentColor, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.accentColor.cgColor
        button.layer.cornerRadius = 3
        button.isHidden = true
        
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .mainScreenBackgroundColor
        contentView.backgroundColor = .mainScreenBackgroundColor
        setupLabel()
        setupAddBtn()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        addSubview(label)
                
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5),
            label.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
        ])
    }
    
    func setupAddBtn() {
        addSubview(addBtn)
                
        NSLayoutConstraint.activate([
            addBtn.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            addBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            addBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
            addBtn.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}
