import UIKit

class UserProfileButtonView: UIView {
    
    let arrowIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "leftArrowIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let btnIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return  image
    }()
    
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
    }
    
    func setupArrowIcon() {
        addSubview(arrowIcon)
        
        arrowIcon.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            arrowIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            arrowIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowIcon.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0164),
            arrowIcon.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.0213)
        ])
    }
    
    func setupButton() {
        addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: btnIcon.trailingAnchor, constant: 20),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        
        ])
        
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
    
}
