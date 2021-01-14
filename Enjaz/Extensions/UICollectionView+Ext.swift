import UIKit

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
    
    func deselectAllItemsExceptAt(_ indexPath: IndexPath, animated: Bool) {
        indexPathsForSelectedItems?.forEach { selectedItemIndexPath in
            if selectedItemIndexPath != indexPath {
                deselectItem(at: selectedItemIndexPath, animated: animated)
            }
        }
    }
    
}
