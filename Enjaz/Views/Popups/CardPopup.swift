

import UIKit

class CardPopup: Popup {
    
    let popupContainerWidth = LayoutConstants.screenWidth * 0.8
    let popupContainerHeight = LayoutConstants.screenHeight * 0.44
    
    var viewModel: CardView? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            cardView.imageView.image = viewModel.imageView.image
            cardView.cardBody.categoryLabel.text = viewModel.cardBody.categoryLabel.text
            cardView.cardBody.titleLabel.text = viewModel.cardBody.titleLabel.text
            cardView.cardBody.descriptionLabel.text = viewModel.cardBody.descriptionLabel.text
            cardView.cardBody.timeLabel.text = viewModel.cardBody.timeLabel.text
        }
    }
    
    lazy var cardView: CardView = {
        let view = CardView()
        view.imageViewSize = popupContainerWidth * 0.41
        view.imageView.asCircle()
        view.cardBody.descriptionLabel.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func onPopupContainerShown() {
        setupPopupContainer()
        setupCardView()
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
    
    func setupCardView() {
        popupContainer.backgroundColor = .clear
        popupContainer.addSubview(cardView)
        
        cardView.cardBody.titleLabel.topAnchor.constraint(equalTo: cardView.imageView.bottomAnchor, constant: (LayoutConstants.screenHeight * 0.035)).isActive = true
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor),
            cardView.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: LayoutConstants.screenHeight * 0.1)
        ])
        
    }

   
}
