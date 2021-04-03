import UIKit
import SPAlert

class NewAdditionScreenVC: KeyboardHandlingViewController, NewAdditionScreenModalDelegate {
    // MARK: Properties
    
    let scrollView = UIScrollView()
        
    let setImageBtn = RoundBtn(image: UIImage(named: "imageIcon"), size: LayoutConstants.screenHeight * 0.11)
    
    let setStickerBtn = RoundBtn(image: UIImage(named: "stickerIconBlue"), size: LayoutConstants.screenHeight * 0.03)
    
    let imagePickerPopup = ImagePickerPopup(hideOnOverlayTap: true)
    let stickerPickerPopup = StickerPickerPopup(hideOnOverlayTap: true)
    
    lazy var additionNameTextField: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: .zero)
        
        let fieldName = NSLocalizedString("Addition Name", comment: "")
        containerView.fieldName = fieldName
        
        let textField = NewAdditionTextField(fieldName: fieldName)
        
        textField.delegate = self
        
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var additionCategoryPopoverBtn: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: .zero)
        
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
    
    lazy var additionDateAndTimeInput: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: .zero)
        
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
    
    lazy var additionDescriptionTextView: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: .zero)
        
        let textView = EditableTextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font = .systemFont(ofSize: 18)
        
        let fieldName = NSLocalizedString("Description", comment: "")
        containerView.fieldName = fieldName
        
        textView.placeholder = fieldName
        
        containerView.input = textView
        
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
    var itemStickerId: Int?
    
    var itemTypeName: String {
        if let itemType = itemType {
            return ItemType.getTypeById(id: itemType).name
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
        setupSetStickerButton()
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
        
        imagePickerPopup.imageSelectionHandler = handleImageSelection
        
        setImageBtn.addTarget(self, action: #selector(handleSetImageBtnTap), for: .touchUpInside)
    }
    
    func setupSetStickerButton() {
        setImageBtn.addSubview(setStickerBtn)
        
        setStickerBtn.backgroundColor = .white
        setStickerBtn.layer.borderWidth = 1
        setStickerBtn.layer.borderColor = UIColor.accentColor.cgColor
        
        setStickerBtn.constrainToSuperviewCorner(at: .bottomTrailing)
        
        stickerPickerPopup.imageSelectionHandler = handleStickerSelection
        
        setStickerBtn.addTarget(self, action: #selector(handleSetStickerBtnTap), for: .touchUpInside)
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
    
    @objc func handleSetStickerBtnTap() {
        dismissKeyboard()
        stickerPickerPopup.present()
    }
    
    func handleImageSelection(selectedId: Int) {
        itemImageId = selectedId
        
        if let imageName = imageIdConstants[selectedId] {
            setImageBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        
        imagePickerPopup.hide()
    }
    
    func handleStickerSelection(selectedId: Int) {
        itemStickerId = selectedId
        
        stickerPickerPopup.hide()
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
        
        guard nonProvidedRequiredFieldNames.isEmpty else {
            let nonProvidedRequiredFieldNamesAsSentence = nonProvidedRequiredFieldNames.joinAsSentence()
            let errorMessage = generateRequiredFieldNamesErrorMessage(requiredFieldNamesAsSentence: nonProvidedRequiredFieldNamesAsSentence, numberOfNonProvidedRequiredFields: nonProvidedRequiredFieldNames.count)
            
            AlertBottomSheetView.shared.presentAsError(withMessage: errorMessage)
            return
        }
        
        saveItem()
        navigationController?.popViewController(animated: true)
        
        let successMessage = generateSuccessMessage(itemTypeName: itemTypeName)
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
        
    func generateRequiredFieldNamesErrorMessage(requiredFieldNamesAsSentence: String, numberOfNonProvidedRequiredFields: Int) -> String {
        if Locale.current.languageCode == "ar" {
            return "يجب ادخال \(requiredFieldNamesAsSentence)."
        }
        
        return "\(requiredFieldNamesAsSentence) field\(numberOfNonProvidedRequiredFields > 1 ? "s" : "") \(String.isOrAre(count: numberOfNonProvidedRequiredFields)) required.".capitalizeOnlyFirstLetter()
    }
    
    func generateSuccessMessage(itemTypeName: String) -> String {
        if Locale.current.languageCode == "ar" {
            return "تم إضافة ال\(itemTypeName) بنجاح"
        }
        
        return "\(itemTypeName) was added successfully"
    }
    
    func saveItem() {
        var index = 0
        var firstItemId: Int!
        
        for date in itemDates! {
            let item = ItemModel()
            
            item.name = itemName
            item.category = itemCategory!
            item.type = itemType
            item.date = date
            item.item_description = itemDescription
            item.image_id = itemImageId ?? -1
            item.sticker_id = itemStickerId ?? -1
            if index == 0 {
                firstItemId = item.id
            } else {
                item.originalItemId = firstItemId
            }
            
            RealmManager.saveItem(item)
            index += 1
        }
    }
        
}

extension NewAdditionScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
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

extension NewAdditionScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
