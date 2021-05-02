import UIKit

class ProgressBarView: UIView {
    
	private var barIcon: RoundImageViewContainer = {
        var image = RoundImageViewContainer()
		image.backgroundColor = .background
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
	private var mainLabel: UILabel = {
        var label = UILabel()
		label.textColor = .highContrastText
        label.font = .systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
	private var subLabel: UILabel = {
        var label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
	private var counterLabel: UILabel = {
        var label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var progressView: UIProgressView = {
        var view = UIProgressView(progressViewStyle: .bar)
        view.trackTintColor = UIColor(hex: 0xD0E9FA)
		view.tintColor = .accent
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
	
	let itemType: ItemType
	
	init(itemType: ItemType) {
		self.itemType = itemType
		super.init(frame: .zero)
		
        backgroundColor = .secondaryBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
		
		barIcon.image = UIImage(named: "\(itemType.name.lowercased())Icon")
		
		setLabels()
        applyLightShadow()
		layer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor.clear.cgColor : UIColor.lightShadow.cgColor
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupSubviews() {
        setupBarIcon()
        setupMainLabel()
        setupSubLabel()
        setupCounterLabel()
        setupProgressView()
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
            subLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
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
    
    func setupProgressView() {
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: counterLabel.leadingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            progressView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.343)
        ])
    }
	
	private func setLabels() {
		let localizedPluralItemTypeName = NSLocalizedString(itemType.name.pluralizeInEnglish(), comment: "").removeDefinitionArticle()
		
		mainLabel.text = String(format: NSLocalizedString("%@ of the month", comment: ""), localizedPluralItemTypeName)
		subLabel.text = String(format: NSLocalizedString("What %@ have you completed", comment: ""), localizedPluralItemTypeName).capitalizeOnlyFirstLetter()
	}
	
	func updateProgressView(totalNumberOfItems: Int, numberOfCompletedItems: Int) {
		updateCounterLabelText(totalNumberOfItems, numberOfCompletedItems)
		progressView.progress = totalNumberOfItems == 0 ? 0 : Float(numberOfCompletedItems)/Float(totalNumberOfItems)
	}
	
	private func updateCounterLabelText(_ totalNumberOfItems: Int, _ numberOfCompletedItems: Int) {
		counterLabel.text = "\(numberOfCompletedItems) \(NSLocalizedString("of", comment: "")) \(totalNumberOfItems) \(NSLocalizedString(itemType.localizedName, comment: ""))"
		
		if Locale.current.languageCode == "en" {
			counterLabel.text! += totalNumberOfItems > 1 ? "s" : ""
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		layer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor.clear.cgColor : UIColor.lightShadow.cgColor
	}
}
