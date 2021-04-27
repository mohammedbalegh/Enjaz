import UIKit

class DraftCardCell: UICollectionViewCell {
    let cornerRadius: CGFloat = 18
        
    lazy var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.roundCorners([.bottomLeading, .bottomTrailing], withRadius: cornerRadius)
        
        return imageView
    }()
    
    let draftMetaDataContainer = DraftMetaDataContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondaryBackground
        layer.cornerRadius = cornerRadius
        applyLightShadow()
		layer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor.clear.cgColor : UIColor.lightShadow.cgColor
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupThumbnail()
        setupArticleMetaDataContainer()
    }
    
    func setupThumbnail() {
        contentView.addSubview(thumbnail)
        
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnail.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.45),
        ])
    }
    
    func setupArticleMetaDataContainer() {
        contentView.addSubview(draftMetaDataContainer)
        draftMetaDataContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            draftMetaDataContainer.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 10),
            draftMetaDataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            draftMetaDataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            draftMetaDataContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		layer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor.clear.cgColor : UIColor.lightShadow.cgColor
	}
}
