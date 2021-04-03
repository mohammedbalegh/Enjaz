import UIKit

class ShowAllItemsScreenVC: ShowAllCardsScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerCardCell() {
        self.collectionView!.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! ItemCardCell
    
        guard let itemModels = cardModels as? [ItemModel] else { return cell }
        
        cell.viewModel = itemModels[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCardCell
        self.cardPopup.present()
        cardPopup.viewModel = cell.cardView
    }

}
