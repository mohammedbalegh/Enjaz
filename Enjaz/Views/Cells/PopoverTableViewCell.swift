import UIKit

class PopoverTableViewCell: UITableViewCell {

	lazy var label: UILabel = {
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: LayoutConstants.calendarViewPopoverWidth, height: frame.height))
		
		label.textColor = .darkGray
		label.font = .systemFont(ofSize: 16)
		label.textAlignment = .center
		
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .white
		
		addSubview(label)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
