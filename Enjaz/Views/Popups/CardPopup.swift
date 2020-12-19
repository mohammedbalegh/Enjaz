

import UIKit

class CardPopup: Popup {
    
    let popupContainerWidth = LayoutConstants.screenWidth * 0.8
    let popupContainerHeight = LayoutConstants.screenHeight * 0.357
    
    let cardBody: CardBodyView = {
        let view = CardBodyView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        label.textColor = UIColor(hex: 0x011942)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(15)
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
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "لوريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم سواء كانت تصاميم مطبوعه  بروشور او فلاير على سبيل المثال او نماذج مواقع انترنت "
        label.textColor = .accentColor
        label.font = label.font.withSize(12)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onPopupContainerShown() {
        setupPopupContainer()
        setupCardBody()
        setupImage()
        setupTitleLabel()
        setupTypeLabel()
        setupTimeLabel()
        setupDescriptionLabel()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardBody.topAnchor, constant: LayoutConstants.screenHeight * 0.088),
            titleLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.7),
            titleLabel.heightAnchor.constraint(equalToConstant: popupContainerHeight * 0.12)
        ])
    }
    
    func setupTypeLabel() {
        addSubview(typeLabel)
    
        self.typeLabel.layer.cornerRadius = (popupContainerHeight * 0.11) / 2;

        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  cardBody.bounds.height * 0.2),
            typeLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.36),
            typeLabel.heightAnchor.constraint(equalToConstant: popupContainerHeight * 0.11)
        ])
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: cardBody.bottomAnchor, constant: cardBody.bounds.height * 0.166),
            timeLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.444),
            timeLabel.heightAnchor.constraint(equalToConstant: popupContainerHeight * 0.19)
        ])
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            descriptionLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.7),
            descriptionLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.06)
        ])
    }
    
    func setupCardBody() {
        addSubview(cardBody)
        
        NSLayoutConstraint.activate([
            cardBody.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor),
            cardBody.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor),
            cardBody.heightAnchor.constraint(equalToConstant: popupContainerHeight),
            cardBody.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor)
        ])
        
    }
    
    func setupPopupContainer() {
        popupContainer.backgroundColor = .clear
        popupContainer.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.heightAnchor.constraint(equalToConstant: popupContainerHeight),
            popupContainer.widthAnchor.constraint(equalToConstant: popupContainerWidth),
        ])
    }
    
    func setupImage() {
        addSubview(image)
        let size = popupContainerWidth * 0.409
        image.layer.cornerRadius = size / 2
        image.clipsToBounds = true
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: size),
            image.heightAnchor.constraint(equalToConstant: size),
            image.bottomAnchor.constraint(equalTo: cardBody.topAnchor, constant: LayoutConstants.screenHeight * 0.050)
        
        ])
    }
}
