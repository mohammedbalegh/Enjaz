
import UIKit

class ItemCardView: UIView {
    
    let imageContainer = UIView(frame: .zero)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    let cardBody: CardBodyView = {
        let view = CardBodyView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageViewSize: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        guard window != nil else { return }
        guard superview != nil else { return }
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupImageContainer()
        setupImageView()
        setupCardBody()
    }
    
    func setupImageContainer() {
        addSubview(imageContainer)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainer.clipsToBounds = true
        
        imageContainer.backgroundColor = UIColor(hex: 0xF2F2F2)
        
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: self.topAnchor, constant: (LayoutConstants.screenHeight * 0.09)),
            imageContainer.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.41),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
        ])
        
        layoutIfNeeded()
        
        imageContainer.layer.cornerRadius = imageContainer.frame.height / 2;
    }

    func setupImageView() {
        imageContainer.addSubview(imageView)
        
        let inset = imageContainer.frame.width * 0.15
        
        imageView.constrainEdgesToCorrespondingEdges(of: imageContainer, top: inset, leading: inset, bottom: -inset, trailing: -inset)
    }
    
    func setupCardBody() {
        addSubview(cardBody)
        
        
        NSLayoutConstraint.activate([
            cardBody.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardBody.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardBody.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardBody.heightAnchor.constraint(equalTo: superview!.heightAnchor, multiplier: 0.703)
        ])
    }
}
