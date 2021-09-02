import UIKit

class TreeCollectionViewCell: UICollectionViewCell {
    
    let treeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage() {
        addSubview(treeImage)
        
        NSLayoutConstraint.activate([
            treeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            treeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            treeImage.heightAnchor.constraint(equalToConstant: 300),
            treeImage.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
