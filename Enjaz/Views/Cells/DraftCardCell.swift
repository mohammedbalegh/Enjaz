import UIKit

class DraftCardCell: UICollectionViewCell {
    let cornerRadius: CGFloat = 18
    
    lazy var thumbnail: DynamicImageView = {
        let imageView = DynamicImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.roundCorners([.bottomLeading, .bottomTrailing], withRadius: cornerRadius)
        
        return imageView
    }()
    
    let draftMetaDataContainer = DraftMetaDataContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = cornerRadius
        applyLightShadow()
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
        
}
