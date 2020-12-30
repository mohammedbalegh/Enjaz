import UIKit

class PopoverBtn: UIButton {

    enum PopoverBtnSizeType {
        case small, large
    }
    
	let label: UILabel = {
		let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
		label.textColor = .lightGray
		label.font = .systemFont(ofSize: 16)
		
		return label
	}()
	
	let dropdownArrow: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "arrowIcon"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.contentMode = .scaleAspectFit
		imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = .lightGray
		
		return imageView
	}()
		
	override var tintColor: UIColor! {
		didSet {
			label.textColor = tintColor
			dropdownArrow.tintColor = tintColor
		}
	}

    func configure(withSize size: PopoverBtnSizeType) {
        setupLabel()
        setupDropdownArrow(size)
    }
	
    func setupLabel() {
        addSubview(label)
        label.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    func setupDropdownArrow(_ size: PopoverBtnSizeType) {
        addSubview(dropdownArrow)
        dropdownArrow.isUserInteractionEnabled = false
        
        let width: CGFloat = size == .large ? 18 : 12
                        
        NSLayoutConstraint.activate([
            dropdownArrow.trailingAnchor.constraint(equalTo: trailingAnchor),
            dropdownArrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            dropdownArrow.heightAnchor.constraint(equalTo: heightAnchor),
            dropdownArrow.widthAnchor.constraint(equalToConstant: width),
        ])
    }
            
}
