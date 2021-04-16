import UIKit

class ProgressBarView: UIView {
    
    var barIcon: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "calendarBadge")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var mainLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hex:0x011942)
        label.font = .systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var subLabel: UILabel = {
        var label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var counterLabel: UILabel = {
        var label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var progressBar: UIProgressView = {
        var view = UIProgressView(progressViewStyle: .bar)
        view.trackTintColor = UIColor(hex: 0xD0E9FA)
        view.tintColor = UIColor(hex: 0x12B3B9)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.masksToBounds = true
        applyLightShadow()
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ mainText: String,_ subText: String,_ totalItems: Int,_ finishedItems: Int) {
        mainLabel.text = mainText
        subLabel.text = subText
        counterLabel.text = "\(finishedItems) \(NSLocalizedString("of", comment: "")) \(totalItems) \(NSLocalizedString("tasks", comment: ""))"
        if totalItems != 0 {
            progressBar.progress = Float(finishedItems)/Float(totalItems)
        } else {
            progressBar.progress = 0
        }
        
    }
    
    func setupSubviews() {
        setupBarIcon()
        setupMainLabel()
        setupSubLabel()
        setupCounterLabel()
        setupProgressBar()
    }
    
    func setupBarIcon() {
        addSubview(barIcon)
        
        let size = LayoutConstants.screenWidth * 0.138
        
        NSLayoutConstraint.activate([
            barIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.screenHeight * 0.027),
            barIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(LayoutConstants.screenWidth * 0.05)),
            barIcon.widthAnchor.constraint(equalToConstant: size),
            barIcon.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupMainLabel() {
        addSubview(mainLabel)

        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            mainLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.03),
            mainLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.4)
        ])
    }
    
    func setupSubLabel() {
        addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 5),
            subLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            subLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.4),
            subLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0246)
        ])
    }
    
    func setupCounterLabel() {
        addSubview(counterLabel)
        
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            counterLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.3),
            counterLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.022)
        ])
    }
    
    func setupProgressBar() {
        addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: counterLabel.leadingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 7),
            progressBar.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.343)
        ])
    }

}
