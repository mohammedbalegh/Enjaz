import UIKit

class ItemRepetitionOptionsTableViewCell: UITableViewCell {

	var option: Date.DateSeparationType? {
		didSet {
			guard let viewModel = option else { return }
			
			label.text = viewModel.rawValue.localized
			
			if viewModel == .custom {
				iconImageView.image = UIImage(systemName: "chevron.forward")
				iconImageView.tintColor = .gray
			} else {
				iconImageView.image = UIImage(systemName: "checkmark")
				iconImageView.tintColor = .accent
			}
		}
	}
		
	let label: UILabel = {
		let label = UILabel(frame: .zero)
				
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let iconImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
		
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSubviews() {
		setupLabel()
		setupIconImageView()
	}
	
	func setupLabel() {
		contentView.addSubview(label)
		
		NSLayoutConstraint.activate([
			label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
			label.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
			label.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.9),
		])
	}
	
	func setupIconImageView() {
		contentView.addSubview(iconImageView)
		
		NSLayoutConstraint.activate([
			iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
			iconImageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.3),
			iconImageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.9),
		])
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		iconImageView.isHidden =  isSelected || option == .custom ? false : true
	}
}
