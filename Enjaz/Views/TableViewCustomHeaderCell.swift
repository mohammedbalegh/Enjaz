import UIKit

class TableViewCustomHeaderCell: UITableViewCell {
	
	var viewModel: ScreenNavigatorTableViewHeaderCellModel? {
		didSet {
			guard let viewModel = viewModel else { return }
			
			label.text = viewModel.title
			let plusIcon = UIImage(systemName: "plus.circle")?.withTintColor(.accent, renderingMode: .alwaysOriginal)
			let attributedAddBtnTitle = viewModel.addBtnTitle?.attributedStringWithImage(plusIcon)
			addBtn.setAttributedTitle(attributedAddBtnTitle, for: .normal)
			addBtn.isHidden = viewModel.addBtnTitle == nil
		}
	}
	
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lowContrastGray
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.6
        return label
    }()
    
    let addBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.accent, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.accent.cgColor
        button.layer.cornerRadius = 4
        button.isHidden = true
        
        return button
    }()
    
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
		setupAddBtn()
        setupLabel()
		addBtn.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupAddBtn() {
        addSubview(addBtn)
		
        NSLayoutConstraint.activate([
            addBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
			addBtn.widthAnchor.constraint(equalToConstant: 170),
            addBtn.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
	
	func setupLabel() {
		addSubview(label)
		
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
			label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
			label.trailingAnchor.constraint(equalTo: addBtn.trailingAnchor),
			label.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
		])
	}
}
