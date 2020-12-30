import UIKit

class StickerPickerPopup: ImageAndStickerPickerPopup {
    override init(hideOnOverlayTap hideOnOverLayTap: Bool) {
        super.init(hideOnOverlayTap: hideOnOverLayTap)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        titleLabel.text = stickerTitleLabel
        imageIconOrSticker.setImage(UIImage(named: "stickerIconWhite"), for: .normal)
    }
}

extension StickerPickerPopup: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerIdConstants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AdditionImageOrStickerCell
        
        if let imageName = stickerIdConstants[indexPath.row] {
            cell.image = UIImage(named: imageName)
        }
                
        return cell
    }
            
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onImageSelected?(indexPath.row)
    }
}
