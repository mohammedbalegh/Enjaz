import UIKit

class ShowMoreButton: UIButton {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupImage()
        setupLabel()
    }
    
    func setupImage() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.035)
        ])
    }
    
    func setupLabel() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
