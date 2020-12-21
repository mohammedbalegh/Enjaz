
import UIKit

class NavBarTabView: UIView {
    
    enum barLabel {
        case title
        case date
    }

	lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray
		label.text = date()
		label.font = label.font.withSize(14)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
    lazy var islamicDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x011942)
        label.text = dateInIslamic()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
	lazy var dateVSV: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [islamicDateLabel, dateLabel])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.axis = .vertical
		stackView.spacing = 5
		
		return stackView
	}()
    let menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(named:"menuIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let billButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(named:"billIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "إضافة جديدة"
        label.textAlignment = .center
        label.textColor = .accentColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupBillButton()
        setupMenuButton()
		setupDateVSV()
//        setupIslamicDateLabel()
//        setupDateLabel()
        setupTitle()
    }
    
    
    func dateInIslamic() -> String {
        let today = Date()
        let islamic = Calendar(identifier: .islamic)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "dd MMMM"
        formatter.calendar = islamic
        formatter.locale = Locale(identifier: "ar_DZ")
        let currentDate = formatter.string(from: today)
        
        return currentDate
    }
    
    func date() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ar_DZ")
        let currentDate = formatter.string(from: today)
        return currentDate
    }
	
	func setupBillButton() {
		addSubview(billButton)
		
		NSLayoutConstraint.activate([
			billButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			billButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (LayoutConstants.screenWidth * 0.058)),
			billButton.heightAnchor.constraint(equalToConstant: LayoutConstants.navBarItemHeight),
			billButton.widthAnchor.constraint(equalToConstant: LayoutConstants.navBarItemWidth)
		])
	}
	
	func setupDateVSV() {
		addSubview(dateVSV)
		
		NSLayoutConstraint.activate([
			dateVSV.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			dateVSV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
		])
	}
    
    func setupTitle() {
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: billButton.centerYAnchor),
            title.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.03),
            title.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.3)
        ])
    }
    
    func setupMenuButton()  {
        addSubview(menuButton)
        
        NSLayoutConstraint.activate([
            menuButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(LayoutConstants.screenWidth * 0.058)),
            menuButton.heightAnchor.constraint(equalToConstant: LayoutConstants.navBarItemHeight),
            menuButton.widthAnchor.constraint(equalToConstant: LayoutConstants.navBarItemWidth)
        ])
    }
}
