import UIKit

class NewAdditionScreenVC: SelectableScreenVC, NewAdditionScreenModalDelegate {
    // MARK: Properties
    
    var scrollView: UIScrollView = {
        var scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.backgroundColor = .rootTabBarScreensBackgroundColor
        return scrollView
    }()
    
    var setImageBtn = RoundBtn(image: UIImage(named: "imageIcon"), size: LayoutConstants.screenHeight * 0.11)
    
    var setStickerBtn = RoundBtn(image: UIImage(named: "stickerIconBlue"), size: LayoutConstants.screenHeight * 0.03)
    
    var imagePickerPopup = ImagePickerPopup(hideOnOverlayTap: true)
    var stickerPickerPopup = StickerPickerPopup(hideOnOverlayTap: true)
    
    var additionNameTextField: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let fieldName = "اسم الإضافة"
        containerView.fieldName = fieldName
        
        let textField = NewAdditionTextField(fieldName: fieldName)
        
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var additionCategoryPopoverBtn: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let button = PopoverBtn(frame: .zero)
        button.configure(withSize: .large)

        button.tintColor = .placeholderText
        
        let fieldName = "مجال الإضافة"
        containerView.fieldName = fieldName
        button.label.text = fieldName
        
        button.frame.size = CGSize(width: 0, height: LayoutConstants.inputHeight)
        button.addTarget(self, action: #selector(onAdditionCategoryPickerTap), for: .touchUpInside)
        
        containerView.input = button
        
        return containerView
    }()
    
    lazy var additionCategoryPickerPopup: PickerPopup = {
        let pickerPopup = PickerPopup(hideOnOverlayTap: true)
        
        pickerPopup.picker.delegate = self
        pickerPopup.picker.dataSource = self
        
        pickerPopup.selectBtn.addTarget(self, action: #selector(onAdditionCategorySelection), for: .touchUpInside)
        pickerPopup.onPopupDismiss = self.onAdditionCategoryPopupDismiss
        
        return pickerPopup
    }()
    
    lazy var additionDateAndTimeInput: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let fieldName = "التاريخ و الوقت"
        containerView.fieldName = fieldName
        
        let textField = NewAdditionTextField(fieldName: fieldName)
        
        textField.frame.size = CGSize(width: 0, height: LayoutConstants.inputHeight)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(onAdditionDateAndTimeInputTap), for: .allTouchEvents)
        
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var additionDescriptionTextView: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let textView = EditableTextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.textViewDidUpdateFocus = descriptionTextViewDidUpdateFocus
        
        textView.font = .systemFont(ofSize: 18)
        
        let fieldName = "الوصف"
        containerView.fieldName = fieldName
        
        textView.placeholder = fieldName
        
        containerView.input = textView
        
        return containerView
    }()
    
    lazy var textFieldsVSV: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [additionNameTextField, additionCategoryPopoverBtn, additionDateAndTimeInput])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = stackViewSpacing
        
        return stackView
    }()
    
    let stackViewSpacing: CGFloat = LayoutConstants.screenHeight * 0.04
    
    let taskTypeModel = TaskType()
    
    var alertPopup = AlertPopup(hideOnOverlayTap: true)
        
    // MARK: State
    
    var selectedAdditionCategoryIndex: Int?
    var selectedTimeStamp: Double?
    var selectedItemTypeID: Int?
    var selectedImageId: Int?
    var selectedStickerId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        definesPresentationContext = true
        
        dismissKeyboardOnTextFieldBlur()
        setupSubviews()
    }
    
    func setupSubviews() {
        setupScrollView()
        setupSetImageButton()
        setupSetStickerButton()
        setupTextFieldsVSV()
        setupAdditionDescriptionTextField()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.fillSuperView()
    }
    
    func setupSetImageButton() {
        view.addSubview(setImageBtn)
        
        NSLayoutConstraint.activate([
            setImageBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            setImageBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        imagePickerPopup.onImageSelected = onImageSelected
        
        setImageBtn.addTarget(self, action: #selector(onSetImageBtnTap), for: .touchUpInside)
    }
    
    func setupSetStickerButton() {
        setImageBtn.addSubview(setStickerBtn)
        
        setStickerBtn.backgroundColor = .white
        setStickerBtn.layer.borderWidth = 1
        setStickerBtn.layer.borderColor = UIColor.accentColor.cgColor
        
        setStickerBtn.constrainToSuperviewCorner(cornerPosition: .bottomLeft)
        
        stickerPickerPopup.onImageSelected = onStickerSelected
        
        setStickerBtn.addTarget(self, action: #selector(onSetStickerBtnTap), for: .touchUpInside)
    }
    
    func setupTextFieldsVSV() {
        view.addSubview(textFieldsVSV)
        
        NSLayoutConstraint.activate([
            textFieldsVSV.topAnchor.constraint(equalTo: setImageBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
            textFieldsVSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsVSV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            textFieldsVSV.heightAnchor.constraint(equalToConstant: LayoutConstants.inputHeight * 3 + stackViewSpacing * 2),
        ])
    }
    
    func setupAdditionDescriptionTextField() {
        view.addSubview(additionDescriptionTextView)
        additionDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            additionDescriptionTextView.topAnchor.constraint(equalTo: textFieldsVSV.bottomAnchor, constant: stackViewSpacing),
            additionDescriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            additionDescriptionTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            additionDescriptionTextView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.17),
        ])
    }
    
    
    // MARK: Event handlers
    
    @objc func onSetImageBtnTap() {
        dismissKeyboard()
        imagePickerPopup.show()
    }
    
    @objc func onSetStickerBtnTap() {
        dismissKeyboard()
        stickerPickerPopup.show()
    }
    
    func onImageSelected(selectedId: Int) {
        selectedImageId = selectedId
        
        if let imageName = imageIdConstants[selectedId] {
            setImageBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        
        imagePickerPopup.hide()
    }
    
    func onStickerSelected(selectedId: Int) {
        selectedStickerId = selectedId
        
        stickerPickerPopup.hide()
    }
    
    @objc func onAdditionCategoryPickerTap() {
        dismissKeyboard()
        additionCategoryPickerPopup.show()
    }
    
    @objc func onAdditionCategorySelection() {
        let selectedValueIndex = additionCategoryPickerPopup.picker.selectedRow(inComponent: 0)
        selectedAdditionCategoryIndex = selectedValueIndex
        let selectedAdditionCategory = taskTypeModel.types[selectedValueIndex]
        guard let input = additionCategoryPopoverBtn.input as? PopoverBtn else { return }
        input.label.text = selectedAdditionCategory
        additionCategoryPickerPopup.hide()
    }
    
    func onAdditionCategoryPopupDismiss() {
        guard let selectedAdditionCategoryIndex = selectedAdditionCategoryIndex else { return }
        additionCategoryPickerPopup.picker.selectRow(selectedAdditionCategoryIndex, inComponent: 0, animated: false)
    }
    
    @objc func onAdditionDateAndTimeInputTap() {
        dismissKeyboard()
        let setDateAndTimeScreenVC = SetDateAndTimeScreenVC()
        setDateAndTimeScreenVC.delegate = self
        present(setDateAndTimeScreenVC, animated: true, completion: nil)
    }
    
    func onDateAndTimeSaveBtnTap(selectedTimeStamp: Double, calendarIdentifier: NSCalendar.Identifier ) {
        self.selectedTimeStamp = selectedTimeStamp
        let selectedDate = Date(timeIntervalSince1970: selectedTimeStamp)
        let formattedDate = DateAndTimeTools.getReadableDate(from: selectedDate, withFormat: "hh:00 aa   dd MMMM yyyy", calendarIdentifier: calendarIdentifier)
        if let additionDateAndTimeTextField = additionDateAndTimeInput.input as? NewAdditionTextField {
            additionDateAndTimeTextField.text = formattedDate
        }
    }
    
    func descriptionTextViewDidUpdateFocus(focused: Bool) {
        focused
            ? tabBarController?.view.translateViewVertically(by: LayoutConstants.screenHeight * 0.22)
            : tabBarController?.view.resetViewVerticalTranslation()
    }
    
    func onTypeSaveBtnTap(id: Int) {
        selectedItemTypeID = id
        saveItem()
    }
    
    func onSaveBtnTap() {
        let nonProvidedRequiredFieldNames = getNonProvidedRequiredFieldNames()
        if !nonProvidedRequiredFieldNames.isEmpty {
            let nonProvidedRequiredFieldNamesAsSentence = nonProvidedRequiredFieldNames.joinAsSentence(languageIsArabic: true)
            alertPopup.showAsError(withMessage: "يجب ادخال \(nonProvidedRequiredFieldNamesAsSentence)")
            return
        }
        
        
        let additionTypeScreenVC = AdditionTypeScreenVC()
        additionTypeScreenVC.delegate = self
        
        present(additionTypeScreenVC, animated: true)
    }
        
    func getItemName() -> String {
        if let nameInput = additionNameTextField.input as? NewAdditionTextField {
            let name = nameInput.text ?? ""
            return name
        }
        
        return ""
    }
    
    func getItemCategoryIndex() -> Int {
        if let popoverBtn = additionCategoryPopoverBtn.input as? PopoverBtn {
            let category = popoverBtn.label.text ?? ""
            let categoryIndex = taskTypeModel.types.firstIndex(of: category)
            return categoryIndex ?? 0
        }
        
        return 0
    }
    
    func getItemDescription() -> String {
        if let textview = additionDescriptionTextView.input as? EditableTextView {
            let description = textview.text ?? ""
            return description
        }
        
        return ""
    }
    
    func getNonProvidedRequiredFieldNames() -> [String] {
        var nonProvidedRequiredFieldNames: [String] = []
        
        let nameIsProvided = !getItemName().isEmpty
        let categoryIsProvided = selectedAdditionCategoryIndex != nil
        let dateIsProvided = selectedTimeStamp != nil
        
        if !nameIsProvided { nonProvidedRequiredFieldNames.append(additionNameTextField.fieldName) }
        if !categoryIsProvided { nonProvidedRequiredFieldNames.append(additionCategoryPopoverBtn.fieldName) }
        if !dateIsProvided { nonProvidedRequiredFieldNames.append(additionDateAndTimeInput.fieldName) }
        
        return nonProvidedRequiredFieldNames
    }
    
    func saveItem() {
        let item = ItemModel()
        item.name = getItemName()
        item.category = selectedAdditionCategoryIndex ?? 0
        item.type = selectedItemTypeID ?? 0
        item.date = selectedTimeStamp ?? 0
        item.item_description = getItemDescription()
        item.image_id = selectedImageId ?? -1
        item.sticker_id = selectedStickerId ?? -1
        RealmManager.saveItem(item)
    }
    
}

extension NewAdditionScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskTypeModel.types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taskTypeModel.types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: taskTypeModel.types[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
}

extension NewAdditionScreenVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension NewAdditionScreenVC: UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.translateViewVertically(by: LayoutConstants.screenHeight * 0.3)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.resetViewVerticalTranslation()
    }
}
