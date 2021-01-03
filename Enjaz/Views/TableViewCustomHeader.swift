import UIKit

class TableViewCustomHeader: UITableViewCell {
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    
    override func layoutSubviews() {
        setupLabel()
    }
    
    func setupLabel() {
        addSubview(label)
                
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width * 0.025),
            label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            label.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
        ])
    }
}
