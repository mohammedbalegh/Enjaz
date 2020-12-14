import UIKit

class CarouselCell: UICollectionViewCell {
    
    let carouselImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    static let reuseID = "carouselCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupImage()
    }
    
    func setupImage() {
        contentView.addSubview(carouselImage)
        
        NSLayoutConstraint.activate([
            carouselImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            carouselImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carouselImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            carouselImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
