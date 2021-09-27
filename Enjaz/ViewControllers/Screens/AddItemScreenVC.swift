import UIKit
import SPAlert

class AddItemScreenVC: KeyboardHandlingViewController, AddItemScreenModalDelegate {
    // MARK: Properties
	
	lazy var thumb: UIView = {
		let width: CGFloat = 35, height: CGFloat = 5
		let thumb = UIView(frame: CGRect(x: view.frame.width / 2 - width / 2, y: 5, width: width, height: height))
		thumb.layer.cornerRadius = height / 2
		thumb.backgroundColor = .lowContrastGray
		return thumb
	}()
	
    let scrollView = UIScrollView()
    
    let itemInfo: [Int?: Any] = [0:0]
	
	lazy var setImageBtn: RoundBtn = {
		let button = RoundBtn()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setImage(UIImage(named: "imageIcon"), for: .normal)
		button.imageView?.contentMode = .scaleAspectFill
		button.backgroundColor = .accent
		
		button.addTarget(self, action: #selector(handleSetImageBtnTap), for: .touchUpInside)
		
		return button
	}()
        
	lazy var imagePickerPopup: ItemImagePickerPopup = {
		let popup = ItemImagePickerPopup()
		popup.delegate = self
		popup.imageCellModels = RealmManager.retrieveDefaultItemImages().map { $0.image_source }
		return popup
	}()
	
    lazy var additionNameTextField: InputFieldContainer = {
        let containerView = InputFieldContainer(frame: .zero)
        
        let fieldName = NSLocalizedString("Addition Name", comment: "")
        containerView.fieldName = fieldName
        
        let textField = InputFieldContainerTextField()
        textField.placeholder = fieldName
        textField.delegate = self
        
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var additionCategoryPopoverBtn: InputFieldContainer = {
        let containerView = InputFieldContainer(frame: .zero)
        
        let button = PopoverBtn(frame: .zero)
        button.configure(withSize: .large)

        button.tintColor = .placeholderText
        
        let fieldName = NSLocalizedString("Addition Category", comment: "")
        containerView.fieldName = fieldName
        button.label.text = fieldName
        
        button.frame.size = CGSize(width: 0, height: LayoutConstants.inputHeight)
        button.addTarget(self, action: #selector(handleAdditionCategoryPickerTap), for: .touchUpInside)
        
        containerView.input = button
        
        return containerView
    }()
    
    lazy var additionCategoryPickerBottomSheet: PickerBottomSheetView = {
        let pickerBottomSheet = PickerBottomSheetView()
        
		pickerBottomSheet.picker.delegate = self
		pickerBottomSheet.picker.dataSource = self
        
		pickerBottomSheet.selectBtn.addTarget(self, action: #selector(handleAdditionCategorySelection), for: .touchUpInside)
        
        return pickerBottomSheet
    }()
    
    lazy var repeatSwitchView: SwitchView = {
        let switchView = SwitchView(frame: .zero)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
        switchView.label.text = String(format: NSLocalizedString("Repeat the %@", comment: ""), itemTypeName.lowercased())
        switchView.descriptionLabel.text = String(format: NSLocalizedString("In case the %@ repeats more than once", comment: ""), itemTypeName.lowercased())
        switchView.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        switchView.isLayoutMarginsRelativeArrangement = true
        switchView.switch.addTarget(self, action: #selector(handleRepeatSwitchValueChange), for: .valueChanged)
        
        return switchView
    }()
    
    lazy var additionDateAndTimeInput: InputFieldContainer = {
        let containerView = InputFieldContainer(frame: .zero)
        
        let fieldName = NSLocalizedString("Date and Time", comment: "")
        containerView.fieldName = fieldName
        
        let button = NewAdditionInputFieldContainerBtn(type: .system)
        
        button.setTitle(fieldName, for: .normal)
        button.setTitleColor(.placeholderText, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = .systemFont(ofSize: 16)
		button.titleLabel?.adjustsFontSizeToFitWidth = true
		button.titleLabel?.minimumScaleFactor = 0.6
        
        button.frame.size = CGSize(width: 0, height: LayoutConstants.inputHeight)
        
        button.addTarget(self, action: #selector(handleAdditionDateAndTimeInputTap), for: .touchUpInside)
        
        containerView.input = button
        
        return containerView
    }()
    
    lazy var textFieldsVerticalStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: getTextFieldsStackArrangedSubviews())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 25
        
        if stackView.arrangedSubviews.contains(repeatSwitchView) {
            stackView.setCustomSpacing(0, after: repeatSwitchView)
        }
        
        return stackView
    }()
    
    lazy var additionDescriptionTextView: InputFieldContainer = {
        let containerView = InputFieldContainer(frame: .zero)
        
        let textView = EditableTextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font = .systemFont(ofSize: 18)
        
        let fieldName = NSLocalizedString("Description", comment: "")
        containerView.fieldName = fieldName
        
        textView.placeholder = fieldName
        
        containerView.input = textView
        
        return containerView
    }()
            
    let saveBtn = PrimaryBtn(label: NSLocalizedString("Save", comment: ""), theme: .blue, size: .large)
    
    var itemCategoryModels: [ItemCategoryModel] = []
    
    var alertPopup = AlertPopup()
	
	var delegate: AddItemScreenDelegate?
	
    
    // MARK: State
    
    var itemName: String {
        return additionNameTextField.input?.inputText ?? ""
    }
    
    var itemDescription: String {
        return additionDescriptionTextView.input?.inputText ?? ""
    }
    
    var repetitionIsTurnedOn: Bool {
        return repeatSwitchView.switch.isOn
    }
    
    var selectedItemCategoryIndex: Int?
    
    var itemCategory: Int?
    var itemPartitionDates: [[TimeInterval]]?
    var itemType: Int!
    var itemImageId: Int?
	
	var nonDefaultItemImage: ItemImageModel?
    
    var itemTypeName: String {
        if let itemType = itemType {
            return ItemType.getTypeById(id: itemType).localizedName
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
				        
		view.backgroundColor = isModal ? .modalScreenBackground : .background
        definesPresentationContext = true
		
		if !isModal {
			thumb.frame = .zero
		}
		
        removeRepetitionSwitchForTypeThatDontSupportRepetition()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = String(format: NSLocalizedString("Add %@", comment: ""), itemTypeName)
        itemCategoryModels = RealmManager.retrieveItemCategories()
		
		let window = UIApplication.shared.windows[0]
		window.backgroundColor = .black
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		let window = UIApplication.shared.windows[0]
		window.backgroundColor = .background
	}
	
    func setupSubviews() {
        setupScrollView()
        setupSetImageButton()
        setupTextFieldsVerticalStack()
        setupAdditionDescriptionTextView()
        setupSaveBtn()
		view.addSubview(thumb)
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.keyboardDismissMode = .interactive
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: keyboardPlaceHolderView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
        ])
    }
	
    func setupSetImageButton() {
        scrollView.addSubview(setImageBtn)
		
        NSLayoutConstraint.activate([
			setImageBtn.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20 + thumb.frame.height),
            setImageBtn.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			setImageBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24),
			setImageBtn.heightAnchor.constraint(equalTo: setImageBtn.widthAnchor),
        ])
    }
        
    func setupTextFieldsVerticalStack() {
        scrollView.addSubview(textFieldsVerticalStack)
        
        let height = textFieldsVerticalStack.calculateHeightBasedOn(arrangedSubviewHeight: LayoutConstants.inputHeight)
        
        NSLayoutConstraint.activate([
            textFieldsVerticalStack.topAnchor.constraint(equalTo: setImageBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.04),
            textFieldsVerticalStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            textFieldsVerticalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            textFieldsVerticalStack.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    func setupAdditionDescriptionTextView() {
        scrollView.addSubview(additionDescriptionTextView)
        additionDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            additionDescriptionTextView.topAnchor.constraint(equalTo: textFieldsVerticalStack.bottomAnchor, constant: textFieldsVerticalStack.spacing),
            additionDescriptionTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            additionDescriptionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            additionDescriptionTextView.heightAnchor.constraint(equalToConstant: 135),
            additionDescriptionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(LayoutConstants.tabBarHeight + 20)),
        ])
    }
    
    func setupSaveBtn() {
        view.addSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        saveBtn.addTarget(self, action: #selector(handleSaveBtnTap), for: .touchUpInside)
    }
    
    // MARK: Event handlers
    
    @objc func handleSetImageBtnTap() {
        dismissKeyboard()
        imagePickerPopup.present(animated: true)
    }
	        
    @objc func handleAdditionCategoryPickerTap() {
        dismissKeyboard()
		additionCategoryPickerBottomSheet.picker.selectRow(selectedItemCategoryIndex ?? 0, inComponent: 0, animated: false)
        additionCategoryPickerBottomSheet.present(animated: true)
    }
    	
    @objc func handleAdditionCategorySelection() {
        (additionCategoryPopoverBtn.input as? PopoverBtn)?.label.textColor = .invertedSystemBackground
        
        let selectedValueIndex = additionCategoryPickerBottomSheet.picker.selectedRow(inComponent: 0)
        
        itemCategory = itemCategoryModels[selectedValueIndex].id
        selectedItemCategoryIndex = selectedValueIndex
        
        let selectedAdditionCategory = itemCategoryModels[selectedValueIndex]
        
        additionCategoryPopoverBtn.input?.inputText = selectedAdditionCategory.localized_name
        additionCategoryPickerBottomSheet.dismiss(animated: true)
    }
        
    @objc func handleAdditionDateAndTimeInputTap() {
        dismissKeyboard()
        
        let setDateAndTimeScreenVC = repetitionIsTurnedOn ? SetDateRangeScreenVC() : SetDateAndTimeScreenVC()
		
		setDateAndTimeScreenVC.itemType = ItemType.getTypeById(id: itemType)
        setDateAndTimeScreenVC.delegate = self
		present(UINavigationController(rootViewController: setDateAndTimeScreenVC), animated: true)
    }
    
    @objc func handleRepeatSwitchValueChange() {
        itemPartitionDates = nil
        (additionDateAndTimeInput.input as? UIButton)?.setTitleColor(.placeholderText, for: .normal)
        additionDateAndTimeInput.input?.inputText = repetitionIsTurnedOn
            ? NSLocalizedString("Date (from - to)", comment: "")
            : additionDateAndTimeInput.fieldName
    }
    
    func handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: [[TimeInterval]], readableDate: String ) {
        self.itemPartitionDates = selectedDatesTimeStamps
        
        (additionDateAndTimeInput.input as? UIButton)?.setTitleColor(.invertedSystemBackground, for: .normal)
        additionDateAndTimeInput.input?.inputText = readableDate
    }
	
	@objc func handleSaveBtnTap() {
        let nonProvidedRequiredFieldNames = getNonProvidedRequiredFieldNames()
        
        if let errorMessage = String.generateRequiredFieldNamesErrorMessage(requiredFieldNames: nonProvidedRequiredFieldNames) {
			showErrorMessage(errorMessage)
            return
        }
        
		if let itemImage = nonDefaultItemImage {
			RealmManager.saveItemImage(itemImage)
		}
		
		NotificationsManager.requestNotificationsPermission()
        saveItem()
				
		if isModal {
			dismiss(animated: true)
			delegate?.didAddItem(self)
		} else {
			navigationController?.popViewController(animated: true)
		}
		
        let successMessage = String(format: NSLocalizedString("%@ was added successfully", comment: ""), itemTypeName)
        SPAlert.present(title: successMessage, preset: .done)
    }
    
    // MARK: Tools
	
	@objc func handleDismissBtnTap() {
		dismiss(animated: true)
	}
    
    func getTextFieldsStackArrangedSubviews() -> [UIView] {
        return [additionNameTextField, additionCategoryPopoverBtn, repeatSwitchView, additionDateAndTimeInput]
    }
    
    func removeRepetitionSwitchForTypeThatDontSupportRepetition() {
        let itemTypeSupportsRepetition = itemType == ItemType.goal.id || itemType == ItemType.task.id || itemType == ItemType.demah.id
                
        if !itemTypeSupportsRepetition {
            textFieldsVerticalStack.removeArrangedSubview(repeatSwitchView)
            repeatSwitchView.removeFromSuperview()
        }
    }
        
    func getNonProvidedRequiredFieldNames() -> [String] {
        var nonProvidedRequiredFieldNames: [String] = []
        
        let nameIsProvided = !itemName.isEmpty
        let categoryIsProvided = itemCategory != nil
        let dateIsProvided = itemPartitionDates != nil
        
        if !nameIsProvided { nonProvidedRequiredFieldNames.append(additionNameTextField.fieldName) }
        if !categoryIsProvided { nonProvidedRequiredFieldNames.append(additionCategoryPopoverBtn.fieldName) }
        if !dateIsProvided { nonProvidedRequiredFieldNames.append(additionDateAndTimeInput.fieldName) }
        
        return nonProvidedRequiredFieldNames
    }
	
	func showErrorMessage(_ errorMessage: String) {
		if isModal {
			alertPopup.presentAsError(withMessage: errorMessage)
		} else {
			AlertBottomSheetView.shared.presentAsError(withMessage: errorMessage)
		}
	}
    
    func saveItem() {
        guard let itemPartitionsDates = itemPartitionDates else { return }
        
		for (partitionIndex, itemPartitionDates) in itemPartitionsDates.enumerated() {
			var firstItemId: Int!
			
			for (dateIndex, date) in itemPartitionDates.enumerated() {
				let item = ItemModel()
				
				item.name = itemName + (itemPartitionsDates.count > 1 ? " \(partitionIndex + 1)" : "")
				item.category_id = itemCategory!
				item.type_id = itemType
				item.date = date
				item.item_description = itemDescription
				item.image_id = itemImageId ?? ItemType.getTypeById(id: itemType).imageId
				if dateIndex == 0 {
					firstItemId = item.id
					if itemPartitionDates.count > 1 {
						item.end_date = itemPartitionDates.last!
					}
				} else {
					item.original_item_id = firstItemId
				}
				
				RealmManager.saveItem(item)
				NotificationsManager.scheduleNotification(forItem: item)
			}
		}
    }
	
}

extension AddItemScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemCategoryModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemCategoryModels[row].localized_name
    }
    
}

extension AddItemScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension AddItemScreenVC: ItemImagePickerPopupDelegate {
	func ImagePickerPopup(_ itemImagePickerPopup: ItemImagePickerPopup, didSelectImage imageId: Int) {
		itemImageId = imageId
		
		if let imageName = RealmManager.retrieveItemImageSourceById(imageId) {
			setImageBtn.setImage(UIImage.getImageFrom(imageName), for: .normal)
		}
		
		imagePickerPopup.dismiss(animated: true)
	}
	
	func ImagePickerPopup(_ itemImagePickerPopup: ItemImagePickerPopup, didSelectImageSource sourceType: UIImagePickerController.SourceType) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = sourceType
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		present(imagePickerController, animated: true)
	}
}

extension AddItemScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		guard let image = info[.editedImage] as? UIImage else { return }
		guard let imageData = image.scalePreservingAspectRatio(targetSize: CGSize(width: 132, height: 125)).toBase64() else { return }
		
		imagePickerPopup.dismiss(animated: true)
		nonDefaultItemImage = ItemImageModel(imageSource: imageData, isDefault: false, isSelectable: false)
		itemImageId = nonDefaultItemImage!.id
		setImageBtn.setImage(UIImage.getImageFrom(imageData), for: .normal)
	}
}
