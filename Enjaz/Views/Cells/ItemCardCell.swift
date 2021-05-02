import UIKit
import Realm

class ItemCardCell: UICollectionViewCell {
    
    var viewModel: ItemModel? {
        didSet {
            cardView.viewModel = viewModel
        }
    }
	
	var itemsUpdateHandler: (() -> Void)? {
		didSet {
			cardView.itemsUpdateHandler = itemsUpdateHandler
		}
	}
    
    var showsCheckBtn: Bool = false {
        didSet {
            cardView.cardBody.showsCheckBtn = showsCheckBtn
        }
    }
	
	var showsDescription: Bool = false {
		didSet {
			cardView.cardBody.descriptionLabel.isHidden = !showsDescription
		}
	}
	
    lazy var cardView = ItemCardView(frame: contentView.frame)
    
    static let reuseID = "cardCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cardView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
