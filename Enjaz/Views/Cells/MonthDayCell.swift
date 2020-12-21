import UIKit

class MonthDayCell: UICollectionViewCell {
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
			
			if viewModel.isSelected {
				label.backgroundColor = .accentColor
				label.textColor = .white
			} else {
				label.backgroundColor = .clear
				label.textColor = .gray
			}
			
		}
	}
	
	lazy var label: UILabel = {
		let label = UILabel(frame: contentView.frame)
		
		label.font = .systemFont(ofSize: 16)
		label.textAlignment = .center
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		label.layer.cornerRadius = contentView.frame.height / 2
		label.layer.masksToBounds = true
		
		contentView.addSubview(label)
	}
		
}
