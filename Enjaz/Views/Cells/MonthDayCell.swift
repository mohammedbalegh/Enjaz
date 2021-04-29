import UIKit

class MonthDayCell: UICollectionViewCell, UIGestureRecognizerDelegate {
	var viewModel: MonthDayCellModel? {
		didSet {
			guard let viewModel = viewModel else { return }
			
			if viewModel.dayNumber == 0 {
				isHidden = true
				isUserInteractionEnabled = false
			} else {
				isHidden = false
				isUserInteractionEnabled = true
			}
            
            itemIndicator.isHidden = !viewModel.includesItem

			label.text = String(viewModel.dayNumber)
		}
	}
	
	lazy var label: UILabel = {
		let label = UILabel(frame: contentView.frame)
		
		label.font = .systemFont(ofSize: 16)
		label.textAlignment = .center
        label.textColor = .gray
		
		return label
	}()
    
    lazy var itemIndicator: UIView = {
        let view = UIView(frame: CGRect(x: contentView.frame.width - (cornerRadius / 2), y: cornerRadius / 2, width: 6, height: 6))
        view.layer.cornerRadius = 2.5
        view.isHidden = true
        view.backgroundColor = .indicator
        
        return view
    }()
    
    lazy var cornerRadius = contentView.frame.height / 2
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                highlightCellAsSelected()
            } else {
                resetCellSelectionHighlight()
                isBetweenSelectionBounds = false
            }
        }
    }
    
    var isBetweenSelectionBounds: Bool = false {
        didSet {
            if isBetweenSelectionBounds {
                highlightCellAsSelectedBetweenSelectionBounds()
            } else {
                isSelected ? highlightCellAsSelected() : resetCellSelectionHighlight()
            }
        }
    }
    
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        
		label.layer.cornerRadius = cornerRadius
		label.layer.masksToBounds = true
		
		contentView.addSubview(label)
        contentView.addSubview(itemIndicator)
	}
		
    // MARK: Tools
    
    func highlightCellAsSelected() {
        label.backgroundColor = .accent
        label.textColor = .white
    }
    
    func highlightCellAsSelectedBetweenSelectionBounds() {
        backgroundColor = UIColor.accent.withAlphaComponent(0.2)
        label.backgroundColor = .clear
        label.textColor = .gray
        layer.maskedCorners = []
    }
    
    func resetCellSelectionHighlight() {
        backgroundColor = .clear
        label.backgroundColor = .clear
        label.textColor = .gray
        layer.maskedCorners = []
    }
}
