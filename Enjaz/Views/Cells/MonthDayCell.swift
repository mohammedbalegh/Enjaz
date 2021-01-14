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
        layer.cornerRadius = contentView.frame.height / 2
        
		label.layer.cornerRadius = contentView.frame.height / 2
		label.layer.masksToBounds = true
		
		contentView.addSubview(label)
	}
		
    // MARK: Tools
    
    func highlightCellAsSelected() {
        label.backgroundColor = .accentColor
        label.textColor = .white
    }
    
    func highlightCellAsSelectedBetweenSelectionBounds() {
        backgroundColor = UIColor.accentColor.withAlphaComponent(0.2)
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
