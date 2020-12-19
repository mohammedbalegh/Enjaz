
import UIKit

class CardInfoView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        label.textColor = UIColor(hex: 0x011942)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        label.numberOfLines = 1
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 0.5
        label.layer.masksToBounds = true
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
    }
    
    func setupSubviews() {
        setupTitleLabel()
        setupTypeLabel()
        setupTimeLabel()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.7),
            titleLabel.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.17)
        ])
    }
    
    func setupTypeLabel() {
        addSubview(typeLabel)
        
        DispatchQueue.main.async {
            self.typeLabel.layer.cornerRadius = self.typeLabel.frame.size.height/2;
        }
        typeLabel.lineBreakMode = .byClipping
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  self.bounds.height * 0.15),
            typeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.3),
            typeLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: self.bounds.height * 0.15 ),
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.444),
            timeLabel.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.19)

        ])
    }
    
}
