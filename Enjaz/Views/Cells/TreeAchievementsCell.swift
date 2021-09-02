import UIKit

class TreeAchievementsCell: UITableViewCell {
    
    var cellCount: UILabel = {
        let label =  UILabel()
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .accent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var messageLabel: UILabel = {
        let label =  UILabel()
        label.font = label.font.withSize(15)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = .highContrastText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCellCount()
        setupGoalLabel()
    }
    
    func setupCellCount() {
        contentView.addSubview(cellCount)
        
        NSLayoutConstraint.activate([
            cellCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cellCount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellCount.heightAnchor.constraint(equalToConstant: 20),
            cellCount.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setupGoalLabel() {
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.trailingAnchor.constraint(equalTo: cellCount.leadingAnchor, constant: -10),
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

}
