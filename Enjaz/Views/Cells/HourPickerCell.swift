

import UIKit

class HourPickerCell: UICollectionViewCell {
    
    var viewModel: HourModel? {
        didSet {
            hourLabel.text = "\(String(describing: viewModel?.hour))"
            periodLabel.text = viewModel?.period
        }
    }
    
    var dateModel: [HourModel] = [HourModel(hour: 1, period: "am"),HourModel(hour: 2, period: "am"),HourModel(hour: 3, period: "am"),HourModel(hour: 4, period: "am"),HourModel(hour: 5, period: "am"),HourModel(hour: 6, period: "am"),HourModel(hour: 7, period: "am"),HourModel(hour: 8, period: "am"),HourModel(hour: 9, period: "am"),HourModel(hour: 10, period: "am"),HourModel(hour: 11, period: "am"),HourModel(hour: 12, period: "am"),HourModel(hour: 1, period: "pm"),HourModel(hour: 2, period: "pm"),HourModel(hour: 3, period: "pm"),HourModel(hour: 4, period: "pm"),HourModel(hour: 5, period: "pm"),HourModel(hour: 6, period: "pm"),HourModel(hour: 7, period: "pm"),HourModel(hour: 8, period: "pm"),HourModel(hour: 9, period: "pm"),HourModel(hour: 10, period: "pm"),HourModel(hour: 11, period: "pm"),HourModel(hour: 12, period: "pm")
    ]
    
    static let reuseID = "hourPickerCell"
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = label.font.withSize(18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = label.font.withSize(9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSubview() {
        setupHourLabel()
        setupPeriodLabel()
    }
    
    func setupHourLabel() {
        contentView.addSubview(hourLabel)
        
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * 0.2),
            hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hourLabel.heightAnchor.constraint(equalToConstant: contentView.bounds.width * 0.5)
        ])
    }
    
    func setupPeriodLabel() {
        contentView.addSubview(periodLabel)
        
        let size = contentView.bounds.width * 0.6
        NSLayoutConstraint.activate([
            periodLabel.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 3),
            periodLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            periodLabel.widthAnchor.constraint(equalToConstant: size),
            periodLabel.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
}
