

import UIKit

class CardPopup: Popup {
    
    let popupContainerWidth = LayoutConstants.screenWidth * 0.8
    let popupContainerHeight = LayoutConstants.screenHeight * 0.44
    
    var viewModel: CardView? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            cardView.image.image = viewModel.image.image
            cardView.cardBody.categoryLabel.text = viewModel.cardBody.categoryLabel.text
            cardView.cardBody.titleLabel.text = viewModel.cardBody.titleLabel.text
            cardView.cardBody.descriptionLabel.text = viewModel.cardBody.descriptionLabel.text
            cardView.cardBody.timeLabel.text = viewModel.cardBody.timeLabel.text
        }
    }
    
    var cardView: CardView = {
        let view = CardView()
        view.image.asCircle()
        view.cardBody.descriptionLabel.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func onPopupContainerShown() {
        setupPopupContainer()
<<<<<<< HEAD
        setupCardBody()
        setupImage()
        setupTitleLabel()
        setupTypeLabel()
        setupTimeLabel()
        setupDescriptionLabel()
    }
    
    func setupTitleLabel() {
        popupContainer.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardBody.topAnchor, constant: LayoutConstants.screenHeight * 0.088),
            titleLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.7),
            titleLabel.heightAnchor.constraint(equalToConstant: popupContainerHeight * 0.12)
        ])
    }
    
    func setupTypeLabel() {
        popupContainer.addSubview(typeLabel)
    
        self.typeLabel.layer.cornerRadius = (popupContainerHeight * 0.11) / 2;

        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  cardBody.bounds.height * 0.2),
            typeLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.36),
            typeLabel.heightAnchor.constraint(equalToConstant: popupContainerHeight * 0.11)
        ])
    }
    
    func setupTimeLabel() {
        popupContainer.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: cardBody.bottomAnchor, constant: cardBody.bounds.height * 0.166),
            timeLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.444),
            timeLabel.heightAnchor.constraint(equalToConstant: popupContainerHeight * 0.19)
        ])
    }
    
    func setupDescriptionLabel() {
        popupContainer.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            descriptionLabel.widthAnchor.constraint(equalToConstant: popupContainerWidth * 0.7),
            descriptionLabel.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.06)
        ])
    }
    
    func setupCardBody() {
        popupContainer.addSubview(cardBody)
        
        NSLayoutConstraint.activate([
            cardBody.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor),
            cardBody.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor),
            cardBody.heightAnchor.constraint(equalToConstant: popupContainerHeight),
            cardBody.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor)
        ])
        
=======
        setupCardView()
>>>>>>> origin/main
    }
    
    func setupPopupContainer() {
        popupContainer.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.heightAnchor.constraint(equalToConstant: popupContainerHeight),
            popupContainer.widthAnchor.constraint(equalToConstant: popupContainerWidth),
        ])
    }
    
<<<<<<< HEAD
    func setupImage() {
        popupContainer.addSubview(image)
        image.backgroundColor = UIColor(hex: 0xF7F7F7)
        image.contentMode = .scaleAspectFit
        let size = popupContainerWidth * 0.409
        image.layer.cornerRadius = size / 2
        image.clipsToBounds = true
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: size),
            image.heightAnchor.constraint(equalToConstant: size),
            image.bottomAnchor.constraint(equalTo: cardBody.topAnchor, constant: LayoutConstants.screenHeight * 0.050)
=======
    func setupCardView() {
        popupContainer.backgroundColor = .clear
        popupContainer.addSubview(cardView)
        
        cardView.cardBody.titleLabel.topAnchor.constraint(equalTo: cardView.image.bottomAnchor, constant: (LayoutConstants.screenHeight * 0.035)).isActive = true
>>>>>>> origin/main
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor),
            cardView.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: LayoutConstants.screenHeight * 0.1)
        ])
        
    }

   
}
