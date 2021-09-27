import UIKit

class ItemCardView: UIView {
    
    var viewModel: ItemModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
			cardBody.item = viewModel
			
			pinBtn.backgroundColor = viewModel.is_pinned ? .accent : .lowContrastGray
			
            if let imageName = RealmManager.retrieveItemImageSourceById(viewModel.image_id) {
                imageView.image = UIImage.getImageFrom(imageName)
            } else {
                imageView.image = nil
            }
            
            let itemCategory = RealmManager.retrieveItemCategoryById(viewModel.category_id)
			
            cardBody.categoryLabel.text = itemCategory?.localized_name
            cardBody.titleLabel.text = viewModel.name
            cardBody.descriptionLabel.text = viewModel.item_description
            cardBody.dateAndTimeLabel.attributedText = Date.getDateAndTimeLabelText(viewModel)
			
			isMinimized = true
        }
    }
	    
	let pinBtn: RoundBtn = {
		let image = UIImage(systemName: "pin.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
		
		let button = RoundBtn()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setImage(image, for: .normal)
		button.imageView?.contentMode = .scaleAspectFit
		
		button.transform = CGAffineTransform(rotationAngle: 45)
		button.addTarget(self, action: #selector(handlePinBtnPress), for: .touchUpInside)
		
		return button
	}()
    
    let imageContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.clipsToBounds = true
		view.backgroundColor = UIColor(hex: 0xF2F2F2) | UIColor(red: 20, green: 20, blue: 22)
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var cardBody: ItemCardBodyView = {
        let view = ItemCardBodyView()
        view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = frame.width * 0.08
        return view
    }()
	
	var pinBtnWidthConstraint: NSLayoutConstraint!
	
	let pinBtnLargeSize: CGFloat = 30
	let pinBtnSmallSize: CGFloat = 20
    
	var isMinimized = true {
		didSet {
			guard let isPinned = viewModel?.is_pinned else { return }
			
			pinBtn.isHidden = isMinimized && !isPinned
			pinBtn.isEnabled = !isMinimized
			
			if isMinimized {
				pinBtnWidthConstraint.constant = pinBtnSmallSize
				pinBtn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
			} else {
				pinBtnWidthConstraint.constant = pinBtnLargeSize
				pinBtn.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
			}
		}
	}
	
	var itemsUpdateHandler: (() -> Void)?
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
		setupPinBtn()
        setupImageContainer()
        setupImageView()
        setupCardBody()
    }
    
	func setupPinBtn() {
		addSubview(pinBtn)
				
		pinBtnWidthConstraint = pinBtn.widthAnchor.constraint(equalToConstant: pinBtnLargeSize)
		
		NSLayoutConstraint.activate([
			pinBtn.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			pinBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
			pinBtnWidthConstraint,
			pinBtn.heightAnchor.constraint(equalTo: pinBtn.widthAnchor),
		])
		
	}
	
    func setupImageContainer() {
        addSubview(imageContainer)
        
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: topAnchor),
            imageContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.41),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
        ])
        
        layoutIfNeeded()
        imageContainer.layer.cornerRadius = imageContainer.frame.height / 2;
    }

    func setupImageView() {
        imageContainer.addSubview(imageView)
        
        let inset = imageContainer.frame.width * 0.15
        
        imageView.constrainEdgesToCorrespondingEdges(of: imageContainer, top: inset, leading: inset, bottom: -inset, trailing: -inset)
    }
    
    func setupCardBody() {
        addSubview(cardBody)
                
        NSLayoutConstraint.activate([
            cardBody.topAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: frame.height * 0.06),
            cardBody.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardBody.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardBody.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
	
	@objc func handlePinBtnPress() {
		guard let item = viewModel else { return }
		let newPinState = !item.is_pinned
		RealmManager.pinItem(item, isPinned: newPinState)
		itemsUpdateHandler?()
		
		Vibration.light.vibrate()
		UIView.animate(withDuration: 0.2) {
			self.pinBtn.backgroundColor = newPinState ? .accent : .lowContrastGray
		}
	}
}
