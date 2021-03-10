import UIKit
import SPAlert

class NewAdditionScreenVC: SelectableScreenVC, NewAdditionScreenModalDelegate {
    // MARK: Properties
    
    let scrollView = UIScrollView()
    
    let scrollViewContentView = UIView()
    
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
        
        pickerPopup.dismissalHanlder = handleAdditionCategoryPopupDismissal
        pickerPopup.selectBtn.addTarget(self, action: #selector(handleAdditionCategorySelection), for: .touchUpInside)
        
        return pickerPopup
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
        stackView.spacing = 35
        
        return stackView
    }()
    
    let taskCategoryModels = ItemCategoryConstants
    
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
    
    // MARK: State
    
    var itemName: String {
        get { return additionNameTextField.input?.inputText ?? "" }
    }
    
    var itemDescription: String {
        get { return additionDescriptionTextView.input?.inputText ?? ""}
    }
    
    var itemCategory: Int?
    var itemDate: Double?
    var itemType: Int?
    var itemImageId: Int?
    var itemStickerId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        definesPresentationContext = true
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupScrollView()
        setupSetImageButton()
        setupSetStickerButton()
        setupTextFieldsVerticalStack()
        setupAdditionDescriptionTextField()
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
    
    func setupAdditionDescriptionTextField() {
        scrollView.addSubview(additionDescriptionTextView)
        additionDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            additionDescriptionTextView.topAnchor.constraint(equalTo: textFieldsVerticalStack.bottomAnchor, constant: textFieldsVerticalStack.spacing),
            additionDescriptionTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            additionDescriptionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            additionDescriptionTextView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.17),
            additionDescriptionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(LayoutConstants.tabBarHeight + 20)),
        ])
    }
    
    
    // MARK: Event handlers
    
    @objc func handleSetImageBtnTap() {
        dismissKeyboard()
        imagePickerPopup.show()
    }
    
    @objc func handleSetStickerBtnTap() {
        dismissKeyboard()
        stickerPickerPopup.show()
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
        
        itemCategory = selectedValueIndex
        
        let selectedAdditionCategory = taskCategoryModels[selectedValueIndex]
        
        additionCategoryPopoverBtn.input?.inputText = selectedAdditionCategory
        additionCategoryPickerBottomSheet.dismiss(animated: true)
    }
    
    func handleAdditionCategoryPopupDismissal() {
        additionCategoryPickerBottomSheet.picker.selectRow(itemCategory ?? 0, inComponent: 0, animated: false)
    }
    
    @objc func handleAdditionDateAndTimeInputTap() {
        dismissKeyboard()
        
        let setDateAndTimeScreenVC = itemType == 3 ? SetGoalDateRangeScreenVC() : SetDateAndTimeScreenVC()
        
        setDateAndTimeScreenVC.delegate = self
        present(setDateAndTimeScreenVC, animated: true, completion: nil)
    }
    
    func handleDateAndTimeSaveBtnTap(selectedTimeStamp: Double, calendarIdentifier: Calendar.Identifier ) {
        self.itemDate = selectedTimeStamp
        let selectedDate = Date(timeIntervalSince1970: selectedTimeStamp)
        let formattedDate = DateAndTimeTools.getReadableDate(from: selectedDate, withFormat: "hh:00 aa | dd MMMM yyyy", calendarIdentifier: calendarIdentifier)
        
        (additionDateAndTimeInput.input as? UIButton)?.setTitleColor(.black, for: .normal)
        
        additionDateAndTimeInput.input?.inputText = formattedDate
    }
    
    @objc func handleSaveBtnTap() {
        let nonProvidedRequiredFieldNames = getNonProvidedRequiredFieldNames()
        if !nonProvidedRequiredFieldNames.isEmpty {
            let nonProvidedRequiredFieldNamesAsSentence = nonProvidedRequiredFieldNames.joinAsSentence(languageIsArabic: true)
            let errorMessage = generateRequiredFieldNamesErrorMessage(requiredFieldNamesAsSentence: nonProvidedRequiredFieldNamesAsSentence, numberOfNonProvidedRequiredFields: nonProvidedRequiredFieldNames.count)
            
            AlertBottomSheetView.shared.presentAsError(withMessage: errorMessage)
            return
        }
        
        let additionTypeScreenVC = AdditionTypeScreenVC()
        additionTypeScreenVC.delegate = self
        
        present(additionTypeScreenVC, animated: true)
    }
    
    func handleTypeSaveBtnTap(id: Int) {
        itemType = id
        
        saveItem()
        resetViewController()
        switchToHomeScreenTab()
        
        let itemTypeName = ItemTypeConstants[id] ?? ""
        let successMessage = generateSuccessMessage(itemTypeName: itemTypeName)
        SPAlert.present(title: successMessage, preset: .done)
    }
    
    // MARK: Tools
    
    func getTextFieldsStackArrangedSubviews() -> [UIView] {
        return [additionNameTextField, additionCategoryPopoverBtn, additionDateAndTimeInput]
    }
    
    func getNonProvidedRequiredFieldNames() -> [String] {
        var nonProvidedRequiredFieldNames: [String] = []
        
        let nameIsProvided = !itemName.isEmpty
        let categoryIsProvided = itemCategory != nil
        let dateIsProvided = itemDate != nil
        
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
            return "تمت إضافة \(itemTypeName) بنجاح"
        }
        
        return "\(itemTypeName) was added successfully"
    }
    
    func saveItem() {
        let item = ItemModel()
        
        item.name = itemName
        item.category = itemCategory ?? 0
        item.type = itemType ?? 0
        item.date = itemDate ?? 0
        item.item_description = itemDescription
        item.image_id = itemImageId ?? -1
        item.sticker_id = itemStickerId ?? -1
        
        RealmManager.saveItem(item)
    }
    
    func resetViewController() {
        resetViewControllerStateValues()
        resetSubviews()
    }
    
    func resetViewControllerStateValues() {
        itemCategory = nil
        itemDate = nil
        itemType = nil
        itemImageId = nil
        itemStickerId = nil
    }
    
    func resetSubviews() {
        setImageBtn.setImage(UIImage(named: "imageIcon"), for: .normal)
                
        imagePickerPopup.collectionView.deselectAllItems(animated: false)
        stickerPickerPopup.collectionView.deselectAllItems(animated: false)
        additionCategoryPickerBottomSheet.picker.selectRow(0, inComponent: 0, animated: false)
        
        
        additionNameTextField.input?.inputText = ""
        additionCategoryPopoverBtn.input?.inputText = additionCategoryPopoverBtn.fieldName
        additionDateAndTimeInput.input?.inputText = additionDateAndTimeInput.fieldName
        additionDescriptionTextView.input?.inputText = ""
        
        (additionCategoryPopoverBtn.input as? PopoverBtn)?.label.textColor = .placeholderText
        (additionDateAndTimeInput.input as? UIButton)?.setTitleColor(.placeholderText, for: .normal)
    }
    
    func switchToHomeScreenTab() {
        tabBarController?.selectedIndex = 0
    }
    
}

extension NewAdditionScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskCategoryModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taskCategoryModels[row]
    }
    
}

extension NewAdditionScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
