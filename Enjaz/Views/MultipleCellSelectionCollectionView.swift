import UIKit

class MultipleCellSelectionCollectionView: UICollectionView {
    
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(toSelectCells:)))
    
    weak var customDelegate: MultipleCellSelectionCollectionViewDelegate?
    
    override weak var delegate: UICollectionViewDelegate? {
        didSet {
            customDelegate = delegate as? MultipleCellSelectionCollectionViewDelegate
        }
    }
    
    override var allowsMultipleSelection: Bool {
        didSet {
            if allowsMultipleSelection {
                addGestureRecognizer(panGesture)
            } else {
                removeGestureRecognizer(panGesture)
            }
        }
    }
    
    var firstSelectedItemIndexPath: IndexPath?
    var lastSelectedItemIndexPath = IndexPath()
    var minimumSelectableItemRow = 0
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        
        canCancelContentTouches = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelectedItems(firstIndexPath: IndexPath, lastIndexPath: IndexPath) {
        // Vibrate on each user initiated item selection
        Vibration.selection.vibrate()
        
        let lowerRowBound = min(firstIndexPath.row, lastIndexPath.row)
        let upperRowBound = max(firstIndexPath.row, lastIndexPath.row)
        let section = firstIndexPath.section
        
        selectAllItemsBetweenTheBounds(lowerRowBound, upperRowBound, inSection: section)
        deselectAllItemsOutsideTheBounds(lowerRowBound, upperRowBound, inSection: section)
        customDelegate?.collectionView(self, didSelectItemAt: lastIndexPath, startedSelectionAt: firstIndexPath)
    }
    
    func selectAllItemsBetweenTheBounds(_ lowerRowBound: Int, _ upperRowBound: Int, inSection section: Int) {
        for i in lowerRowBound...upperRowBound {
            let indexPath = IndexPath(row: i, section: section)
            guard let cell = cellForItem(at: indexPath) else { continue }
            
            if !cell.isSelected {
                selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            }
        }
    }
    
    func deselectAllItemsOutsideTheBounds(_ lowerRowBound: Int, _ upperRowBound: Int, inSection section: Int) {
        indexPathsForSelectedItems?.forEach { selectedItemIndexPath in
            guard selectedItemIndexPath.section == section else { return }
            
            if !((lowerRowBound...upperRowBound) ~= selectedItemIndexPath.row) {
                deselectItem(at: selectedItemIndexPath, animated: true)
            }
        }
    }
    
    @objc func didPan(toSelectCells panGesture: UIPanGestureRecognizer) {
        guard allowsMultipleSelection else {
            return
        }
        
        let location: CGPoint = panGesture.location(in: self)
        let currentIndexPath = indexPathForItem(at: location)
        
        if panGesture.state == .began {
            isUserInteractionEnabled = false
            firstSelectedItemIndexPath = nil
            return
        }
        
        if panGesture.state == .changed {
            if let currentIndexPath = currentIndexPath, currentIndexPath != lastSelectedItemIndexPath, currentIndexPath.row >= minimumSelectableItemRow {
                if firstSelectedItemIndexPath == nil {
                    firstSelectedItemIndexPath = currentIndexPath
                }
                
                lastSelectedItemIndexPath = currentIndexPath
                
                updateSelectedItems(firstIndexPath: firstSelectedItemIndexPath!, lastIndexPath: lastSelectedItemIndexPath)
            }
            return
        }
        
        if panGesture.state == .ended {
            isUserInteractionEnabled = true
            customDelegate?.didEndMultipleSelection(self)
        }
    }
    
}
