import UIKit
import SPAlert

class HourTableViewCell: UITableViewCell {

    var viewModel: DailyViewHourModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            let splitHour = viewModel.hour.split(separator: " ")
            let hour = splitHour.count >= 1 ? String(splitHour[0]) : ""
            let period = splitHour.count == 2 ? String(splitHour[1]) : ""
            
            hourLabel.text = hour
            hourPeriodLabel.text = period
            
            imageViewContainer.isHidden = !viewModel.includesItems
            firstItemLabel.isHidden = imageViewContainer.isHidden
            
            let includesMoreThanOneItem = viewModel.includedItems.count > 1
            
            otherIncludedItemsLabelText = viewModel.includedItems.count > 1 ? "+\(viewModel.includedItems.count - 1)" : ""
            
            if viewModel.includesItems {
                let firstItem = viewModel.includedItems[0]
                if let imageName = RealmManager.retrieveItemImageSourceById(firstItem.image_id) {
                    firstItemImageView.image = UIImage.getImageFrom(imageName)
                } else {
                    firstItemImageView.image = nil
                }
                
                firstItemLabel.attributedText = (firstItem.name + " " + otherIncludedItemsLabelText).attributedStringWithColor([otherIncludedItemsLabelText], color: .accent, stringSize: 11, coloredSubstringsSize: 9)
            } else {
                firstItemImageView.image = nil
                firstItemLabel.attributedText = NSAttributedString(string: "")
            }
            
            showAllOrLessBtn.isHidden = !includesMoreThanOneItem
            
            isShowingAllIncludedItems = viewModel.isShowingAllIncludedItems
        }
    }
	
	var unixTimeStamp: TimeInterval? {
		didSet {
			if let unixTimeStamp = unixTimeStamp, unixTimeStamp < Date().timeIntervalSince1970 {
				addGestureRecognizer(longPressAnd3dTouchGestureRecognizer)
			} else {
				removeGestureRecognizer(longPressAnd3dTouchGestureRecognizer)
			}
		}
	}
    
	lazy var longPressAnd3dTouchGestureRecognizer = LongPressAnd3dTouchGestureRecognizer(target: self, action: #selector(handleLongPressOr3dTouch))
	
    let hourLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = label.font.withSize(12.5)
        return label
    }()
    
    let hourPeriodLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemGray2
        label.font = label.font.withSize(7.5)
        return label
    }()
    
    lazy var hourAndPeriodLabelsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hourLabel, hourPeriodLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
            
    let imageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .accent
        view.isHidden = true
        view.clipsToBounds = true
        
        return view
    }()
    
    let firstItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let firstItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .highContrastGray
        label.font = label.font.withSize(11)
        label.isHidden = true
        
        return label
    }()
    
    lazy var showAllOrLessBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(NSLocalizedString("Show All", comment: ""), for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleShowAllOrLessBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    var otherIncludedItemsLabelText = ""
    
    var row : Int = -1
    var showAllBtnHandler: ((_ rowIndex: Int) -> Void)?
    var showLessBtnHandler: ((_ rowIndex: Int) -> Void)?
    
    var isShowingAllIncludedItems = false {
        didSet {
            let showAllOrLessBtnTitle = isShowingAllIncludedItems
                ? NSLocalizedString("Hide Rest", comment: "")
                : NSLocalizedString("Show All", comment: "")
            
            showAllOrLessBtn.setTitle(showAllOrLessBtnTitle, for: .normal)

            let firstItemLabelText = firstItemLabel.text ?? ""

            if isShowingAllIncludedItems {
                let updatedFirstItemLabelText = firstItemLabelText.replacingOccurrences(of: otherIncludedItemsLabelText, with: "")
                firstItemLabel.attributedText = NSAttributedString(string: updatedFirstItemLabelText)
            } else {
                guard !firstItemLabelText.contains(otherIncludedItemsLabelText) else { return }
                firstItemLabel.attributedText = (firstItemLabelText + otherIncludedItemsLabelText).attributedStringWithColor([otherIncludedItemsLabelText], color: .accent, stringSize: 11, coloredSubstringsSize: 9)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .secondaryBackground
		contentView.backgroundColor = .secondaryBackground
		selectionStyle = .none
		
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupHourAndPeriodLabelsStack()
        setupImageViewContainer()
        setupFirstItemImageView()
        setupShowAllBtn()
        setupFirstItemLabel()
    }
    
    func setupHourAndPeriodLabelsStack() {
        contentView.addSubview(hourAndPeriodLabelsStack)
        
        NSLayoutConstraint.activate([
            hourAndPeriodLabelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            hourAndPeriodLabelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            hourAndPeriodLabelsStack.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
            hourAndPeriodLabelsStack.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setupImageViewContainer() {
        contentView.addSubview(imageViewContainer)
        let size: CGFloat = contentView.frame.height * 0.68
        
        NSLayoutConstraint.activate([
            imageViewContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewContainer.leadingAnchor.constraint(equalTo: hourAndPeriodLabelsStack.trailingAnchor, constant: 10),
            imageViewContainer.heightAnchor.constraint(equalToConstant: size),
            imageViewContainer.widthAnchor.constraint(equalToConstant: size),
        ])
        
        imageViewContainer.layer.cornerRadius = size / 2
    }
    
    func setupFirstItemImageView() {
        imageViewContainer.addSubview(firstItemImageView)
        
        firstItemImageView.constrainEdgesToCorrespondingEdges(of: imageViewContainer, top: 6, leading: 6, bottom: -6, trailing: -6)
    }
    
    func setupShowAllBtn() {
        contentView.addSubview(showAllOrLessBtn)
        
        NSLayoutConstraint.activate([
            showAllOrLessBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            showAllOrLessBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            showAllOrLessBtn.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
            showAllOrLessBtn.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
        ])
    }
    
    func setupFirstItemLabel() {
        contentView.addSubview(firstItemLabel)
        
        NSLayoutConstraint.activate([
            firstItemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            firstItemLabel.leadingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor, constant: 6),
            firstItemLabel.trailingAnchor.constraint(lessThanOrEqualTo: showAllOrLessBtn.leadingAnchor, constant: 5),
            firstItemLabel.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
        ])
    }
    
    @objc func handleShowAllOrLessBtnTapped() {
        isShowingAllIncludedItems ? showLessBtnHandler?(row) : showAllBtnHandler?(row)
        isShowingAllIncludedItems = !isShowingAllIncludedItems
    }
	
	@objc func handleLongPressOr3dTouch(gesture: LongPressAnd3dTouchGestureRecognizer) {
		if gesture.state == .began {
			SPAlert.present(message: NSLocalizedString("Cannot add a task in the past", comment: ""), haptic: .error)
		}
	}
}
