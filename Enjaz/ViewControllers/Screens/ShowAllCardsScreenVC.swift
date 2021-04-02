import UIKit

class ShowAllCardsScreenVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cardsReuseIdentifier = "CardCell"
    let headerReuseIdentifier = "HeaderCell"
    
    var cardModels: [Any] = []

    let cardPopup = CardPopup(hideOnOverlayTap: true)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainScreenBackgroundColor
        collectionView.backgroundColor = .none
        
        self.collectionView!.register(CardsCollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        registerCardCell()
    }
    // @abstarct
    func registerCardCell() {}

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CardsCollectionViewHeaderCell
            headerView.header.titleLabel.text = title
            headerView.header.cardsCount = cardModels.count
            
            return headerView
        
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offSet = LayoutConstants.screenWidth * 0.054
        return UIEdgeInsets(top: 0, left: offSet, bottom: 0, right: offSet)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width * 0.4), height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        25
    }
}
