import UIKit

class ImagePickerPopup: ImageAndStickerPickerPopup {
    override func configure() {
        titleLabel.text = imageTitleLabel
        collectionView.delegate = self
        collectionView.dataSource = self
        titleLabel.text = imageTitleLabel
        imageIconOrSticker.setImage(UIImage(named: "imageIcon"), for: .normal)
    }
}

extension ImagePickerPopup: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageIdConstants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AdditionImageOrStickerCell
        
        if let imageName = imageIdConstants[indexPath.row] {
            cell.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageSelectionHandler?(indexPath.row)
    }
}
