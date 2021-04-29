import UIKit

class ItemImagePickerImageSourceCell: UICollectionViewCell {
	var viewModel: ItemImagePickerImageSourceCellModel? {
		didSet {
			imageView.image = UIImage(named: viewModel?.imageSource ?? "")
			label.text = viewModel?.label
		}
	}
	
	let imageView = UIImageView(frame: .zero)
	let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.font = label.font.withSize(10)
		label.textColor = .systemGray2
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		layer.cornerRadius = 10
		setupImageView()
		setupLabel()
	}
	
	func setupImageView() {
		contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.contentMode = .scaleAspectFit
		
		NSLayoutConstraint.activate([
			imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
			imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			imageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.5),
			imageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
		])
	}
	
	func setupLabel() {
		contentView.addSubview(label)
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
			label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			label.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.2),
			label.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
		])
	}
	
}
