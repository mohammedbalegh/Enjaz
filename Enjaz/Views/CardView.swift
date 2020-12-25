
import UIKit

class CardView: UIView {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .rootTabBarScreensBackgroundColor
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let cardBody: CardBodyView = {
        let view = CardBodyView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        setupCardBody()
        setupImage()
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
    
    func setupImage() {
        addSubview(image)
        
        DispatchQueue.main.async {
            self.image.layer.cornerRadius = self.image.frame.size.height/2;
        }

        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: cardBody.centerXAnchor),
            image.bottomAnchor.constraint(equalTo: self.topAnchor, constant: (LayoutConstants.screenHeight * 0.09)),
            image.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.41),
            image.heightAnchor.constraint(equalTo: image.widthAnchor)
            
        
        ])
    }

}
