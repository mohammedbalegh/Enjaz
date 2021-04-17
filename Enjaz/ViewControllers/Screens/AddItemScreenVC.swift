import UIKit
import SPAlert

class AddItemScreenVC: KeyboardHandlingViewController, AddItemScreenModalDelegate {
    // MARK: Properties
    
    let scrollView = UIScrollView()
        
    let setImageBtn = RoundBtn(image: UIImage(named: "imageIcon"), size: LayoutConstants.screenHeight * 0.11)
        
	lazy var imagePickerPopup: ItemImagePickerPopup = {
		let popup = ItemImagePickerPopup(hideOnOverlayTap: true)
		popup.delegate = self
		popup.imageCellModels = RealmManager.retrieveItemImages().map { $0.image_source }
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
        let pickerPopup = PickerBottomSheetView()
        
        pickerPopup.picker.delegate = self
        pickerPopup.picker.dataSource = self
        
        pickerPopup.dismissalHandler = handleAdditionCategoryPopupDismissal
        pickerPopup.selectBtn.addTarget(self, action: #selector(handleAdditionCategorySelection), for: .touchUpInside)
        
        return pickerPopup
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
    
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
    
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
    var itemDates: [Double]?
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
        
        view.backgroundColor = .mainScreenBackgroundColor
        definesPresentationContext = true
        
        removeRepetitionSwitchForTypeThatDontSupportRepetition()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = String(format: NSLocalizedString("Add %@", comment: ""), itemTypeName)
        itemCategoryModels = RealmManager.retrieveItemCategories()
    }
    
    func setupSubviews() {
        setupScrollView()
        setupSetImageButton()
        setupTextFieldsVerticalStack()
        setupAdditionDescriptionTextView()
        setupSaveBtn()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
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
            setImageBtn.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            setImageBtn.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        setImageBtn.addTarget(self, action: #selector(handleSetImageBtnTap), for: .touchUpInside)
    }
        
    func setupTextFieldsVerticalStack() {
        scrollView.addSubview(textFieldsVerticalStack)
        
        let height = textFieldsVerticalStack.calculateHeightBasedOn(arrangedSubviewHeight: LayoutConstants.inputHeight)
        
        NSLayoutConstraint.activate([
            textFieldsVerticalStack.topAnchor.constraint(equalTo: setImageBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
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
        imagePickerPopup.present()
    }
	        
    @objc func handleAdditionCategoryPickerTap() {
        dismissKeyboard()
        additionCategoryPickerBottomSheet.present(animated: true)
    }
    	
    @objc func handleAdditionCategorySelection() {
        (additionCategoryPopoverBtn.input as? PopoverBtn)?.label.textColor = .black
        
        let selectedValueIndex = additionCategoryPickerBottomSheet.picker.selectedRow(inComponent: 0)
        
        itemCategory = itemCategoryModels[selectedValueIndex].id
        selectedItemCategoryIndex = selectedValueIndex
        
        let selectedAdditionCategory = itemCategoryModels[selectedValueIndex]
        
        additionCategoryPopoverBtn.input?.inputText = selectedAdditionCategory.localized_name
        additionCategoryPickerBottomSheet.dismiss(animated: true)
    }
    
    func handleAdditionCategoryPopupDismissal() {
        additionCategoryPickerBottomSheet.picker.selectRow(selectedItemCategoryIndex ?? 0, inComponent: 0, animated: false)
    }
    
    @objc func handleAdditionDateAndTimeInputTap() {
        dismissKeyboard()
        
        let setDateAndTimeScreenVC = repetitionIsTurnedOn ? SetDateRangeScreenVC() : SetDateAndTimeScreenVC()
        
        setDateAndTimeScreenVC.delegate = self
        present(setDateAndTimeScreenVC, animated: true, completion: nil)
    }
    
    @objc func handleRepeatSwitchValueChange() {
        itemDates = nil
        (additionDateAndTimeInput.input as? UIButton)?.setTitleColor(.placeholderText, for: .normal)
        additionDateAndTimeInput.input?.inputText = repetitionIsTurnedOn
            ? NSLocalizedString("Date (from - to)", comment: "")
            : additionDateAndTimeInput.fieldName
    }
    
    func handleDateAndTimeSaveBtnTap(selectedDatesTimeStamps: [Double], readableDate: String ) {
        self.itemDates = selectedDatesTimeStamps
        
        (additionDateAndTimeInput.input as? UIButton)?.setTitleColor(.black, for: .normal)
        additionDateAndTimeInput.input?.inputText = readableDate
    }
    
    @objc func handleSaveBtnTap() {
        let nonProvidedRequiredFieldNames = getNonProvidedRequiredFieldNames()
        
        if let errorMessage = String.generateRequiredFieldNamesErrorMessage(requiredFieldNames: nonProvidedRequiredFieldNames) {
            AlertBottomSheetView.shared.presentAsError(withMessage: errorMessage)
            return
        }
        
		if let itemImage = nonDefaultItemImage {
			RealmManager.saveItemImage(itemImage)
		}
		
        saveItem()
        navigationController?.popViewController(animated: true)
        
        let successMessage = String.generateAdditionSuccessMessage(type: itemTypeName)
        SPAlert.present(title: successMessage, preset: .done)
    }
    
    // MARK: Tools
    
    func getTextFieldsStackArrangedSubviews() -> [UIView] {
        return [additionNameTextField, additionCategoryPopoverBtn, repeatSwitchView, additionDateAndTimeInput]
    }
    
    func removeRepetitionSwitchForTypeThatDontSupportRepetition() {
        let itemTypeSupportsRepetition = itemType == ItemType.goal.id || itemType == ItemType.task.id
                
        if !itemTypeSupportsRepetition {
            textFieldsVerticalStack.removeArrangedSubview(repeatSwitchView)
            repeatSwitchView.removeFromSuperview()
        }
    }
        
    func getNonProvidedRequiredFieldNames() -> [String] {
        var nonProvidedRequiredFieldNames: [String] = []
        
        let nameIsProvided = !itemName.isEmpty
        let categoryIsProvided = itemCategory != nil
        let dateIsProvided = itemDates != nil
        
        if !nameIsProvided { nonProvidedRequiredFieldNames.append(additionNameTextField.fieldName) }
        if !categoryIsProvided { nonProvidedRequiredFieldNames.append(additionCategoryPopoverBtn.fieldName) }
        if !dateIsProvided { nonProvidedRequiredFieldNames.append(additionDateAndTimeInput.fieldName) }
        
        return nonProvidedRequiredFieldNames
    }
    
    func saveItem() {
        var firstItemId: Int!
        
        guard let itemDates = itemDates else { return }
        
		for (index, date) in itemDates.enumerated() {
            let item = ItemModel()
            
            item.name = itemName
            item.category = itemCategory!
            item.type = itemType
            item.date = date
            item.item_description = itemDescription
            item.image_id = itemImageId ?? -1
            if index == 0 {
                firstItemId = item.id
                if itemDates.count > 1 {
                    item.endDate = itemDates.last!
                }
            } else {
                item.originalItemId = firstItemId
            }
            
            RealmManager.saveItem(item)
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
		
		imagePickerPopup.dismiss()
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
		
		nonDefaultItemImage = ItemImageModel(imageSource: imageData, isDefault: false)
		itemImageId = nonDefaultItemImage!.id
		setImageBtn.setImage(UIImage.getImageFrom(imageData), for: .normal)
	}
}
