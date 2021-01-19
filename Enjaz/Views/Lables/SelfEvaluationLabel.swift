
import UIKit

class SelfEvaluationLabel: UILabel {
    
    let circleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "yellowCircleIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let crossImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "redCrossIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .accentColor
        label.font = label.font.withSize(15)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.1
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
        setupCircleImage()
        setupCrossImage()
        setupLabel()
    }
    
    func setupCircleImage() {
        addSubview(circleImage)
        
        circleImage.constrainToSuperviewCorner(at: .bottomTrailing)
        
        NSLayoutConstraint.activate([
            circleImage.heightAnchor.constraint(equalToConstant: 7),
            circleImage.widthAnchor.constraint(equalToConstant: 7)
        ])
    }
 
    func setupCrossImage() {
        addSubview(crossImage)
        
        crossImage.constrainToSuperviewCorner(at: .topLeading)
        
        NSLayoutConstraint.activate([
            crossImage.heightAnchor.constraint(equalToConstant: 10),
            crossImage.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func setupLabel() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
}
