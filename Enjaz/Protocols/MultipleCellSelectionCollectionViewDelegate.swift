import UIKit

protocol MultipleCellSelectionCollectionViewDelegate: UICollectionViewDelegate {
            
    func collectionView(_ collectionView: MultipleCellSelectionCollectionView, didSelectItemAt indexPath: IndexPath, startedSelectionAt firstSelectedItemIndexPath: IndexPath)
    
    func didEndMultipleSelection(_ collectionView: MultipleCellSelectionCollectionView)
    
}
