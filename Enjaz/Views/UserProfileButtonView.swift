import UIKit

class UserProfileButtonView: UIView {
    	
    let arrowIcon: UIImageView = {
        let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.image = UIImage(systemName: "chevron.forward")?.withTintColor(.lowContrastGray, renderingMode: .alwaysOriginal)
        return image
    }()
    
    let button: UIButton = {
        let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(.lowContrastGray, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
	
    let btnIcon: UIImageView = {
        let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return  image
    }()
	
	let bottomBorder = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupBtnIcon()
        setupButton()
        setupArrowIcon()
		setupBottomBorder()
    }
	
	func setupBtnIcon() {
		addSubview(btnIcon)
		
		NSLayoutConstraint.activate([
			btnIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			btnIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			btnIcon.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.032),
			btnIcon.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.05)
		])
	}
        
    func setupButton() {
        addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: btnIcon.trailingAnchor, constant: 20),
            button.topAnchor.constraint(equalTo: self.topAnchor),
			button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.5),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])		
    }
    	
	func setupArrowIcon() {
		addSubview(arrowIcon)
		
		NSLayoutConstraint.activate([
			arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
			arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
			arrowIcon.heightAnchor.constraint(equalToConstant: 20),
			arrowIcon.widthAnchor.constraint(lessThanOrEqualToConstant: 35),
		])
	}
	
	func setupBottomBorder() {
		addSubview(bottomBorder)
		bottomBorder.translatesAutoresizingMaskIntoConstraints = false
		bottomBorder.backgroundColor = .lowContrastGray
		
		NSLayoutConstraint.activate([
			bottomBorder.topAnchor.constraint(equalTo: button.bottomAnchor),
			bottomBorder.leadingAnchor.constraint(equalTo: button.leadingAnchor),
			bottomBorder.trailingAnchor.constraint(equalTo: button.trailingAnchor),
			bottomBorder.heightAnchor.constraint(equalToConstant: 0.5),
		])
	}
    
}
