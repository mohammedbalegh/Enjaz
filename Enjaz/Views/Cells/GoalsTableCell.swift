
import UIKit

class GoalsTableCell: UITableViewCell {
    
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
    
    var goalLabel: UILabel = {
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
        contentView.backgroundColor = .background
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
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
            cellCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellCount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellCount.heightAnchor.constraint(equalToConstant: 10),
            cellCount.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func setupGoalLabel() {
        contentView.addSubview(goalLabel)
        
        NSLayoutConstraint.activate([
            goalLabel.leadingAnchor.constraint(equalTo: cellCount.trailingAnchor, constant: LayoutConstants.screenWidth * 0.036),
            goalLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            goalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            goalLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.022)
        ])
    }
}
