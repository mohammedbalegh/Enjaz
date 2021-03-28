import UIKit

class NoteCategoryPickerView: UIView {
    
    let size = LayoutConstants.screenHeight * 0.015
    
    var rightIcon: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "noteIcon-1")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var leftIcon: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "arrowIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var noteCategoryBtn: UIButton = {
        var button = UIButton()
        button.setTitleColor(.placeholderText, for: .normal)
        button.setTextViewDirectionToMatchSuperView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupRightIcon()
        setupLeftIcon()
        setupNoteCategoryBtn()
    }
    
    func setupRightIcon() {
        addSubview(rightIcon)
        
        NSLayoutConstraint.activate([
            rightIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            rightIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightIcon.widthAnchor.constraint(equalToConstant: size),
            rightIcon.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupLeftIcon() {
        addSubview(leftIcon)
        
        NSLayoutConstraint.activate([
            leftIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            leftIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leftIcon.widthAnchor.constraint(equalToConstant: size),
            leftIcon.heightAnchor.constraint(equalToConstant: size / 2)
        ])
    }
    
    func setupNoteCategoryBtn() {
        addSubview(noteCategoryBtn)

        NSLayoutConstraint.activate([
            noteCategoryBtn.leadingAnchor.constraint(equalTo: rightIcon.trailingAnchor, constant: 10),
            noteCategoryBtn.trailingAnchor.constraint(equalTo: leftIcon.leadingAnchor, constant: -10),
            noteCategoryBtn.topAnchor.constraint(equalTo: self.topAnchor),
            noteCategoryBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
