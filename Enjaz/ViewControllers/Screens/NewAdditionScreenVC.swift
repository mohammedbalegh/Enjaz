import UIKit

class NewAdditionScreenVC: UIViewController, NewAdditionScreenModalDelegate {
    // MARK: Properties
    
    var scrollView: UIScrollView = {
        var scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.backgroundColor = .rootTabBarScreensBackgroundColor
        return scrollView
    }()
    
    var setImageBtn = RoundBtn(image: UIImage(named: "imageIcon"), size: LayoutConstants.screenHeight * 0.11)
    
    var setStickerBtn = RoundBtn(image: UIImage(named: "stickerIconBlue"), size: LayoutConstants.screenHeight * 0.03)
    
    var imageAndStickerPopup = ImageAndStickerPickerPopup()
    
    var additionNameTextField: NewAdditionInputFeildContainer = {
        let containerView = NewAdditionInputFeildContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let textField = NewAdditionTextField(fieldName: "اسم الإضافة")
        
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var additionCategoryPopoverBtn: NewAdditionInputFeildContainer = {
        let containerView = NewAdditionInputFeildContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let button = PopoverBtn(frame: .zero)
        
        button.label.text = "مجال الإضافة"
        
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
        pickerPopup.onPopupDismiss = self.onAdditionPopupDismiss
        
        return pickerPopup
    }()
    
    lazy var additionDateAndTimeInput: NewAdditionInputFeildContainer = {
        let containerView = NewAdditionInputFeildContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let textField = NewAdditionTextField(fieldName: "التاريخ و الوقت")
        
        textField.frame.size = CGSize(width: 0, height: LayoutConstants.inputHeight)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(onAdditionDateAndTimeInputTap), for: .allTouchEvents)
        
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var additionDescriptionTextView: NewAdditionInputFeildContainer = {
        let containerView = NewAdditionInputFeildContainer(frame: CGRect(x: 0, y: 0, width: 60, height: LayoutConstants.inputHeight))
        
        let textView = EditableTextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        textView.font = .systemFont(ofSize: 18)
        
        textView.placeholder = "الوصف"
        
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
    
    var selectedTimeStamp: Double?
    var selectedItemTypeID: Int?
    
    // MARK: State
    
    var selectedCategoryIndex = 0
    var selectedAdditionTypeIndex = 0
    var additionType = ""
    
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
            setImageBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.toolBarHeight - LayoutConstants.toolBarHeight * 0.25),
            setImageBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        setImageBtn.addTarget(self, action: #selector(onSetImageBtnTap), for: .touchUpInside)
    }
    
    func setupSetStickerButton() {
        setImageBtn.addSubview(setStickerBtn)
        
        setStickerBtn.backgroundColor = .white
        setStickerBtn.layer.borderWidth = 1
        setStickerBtn.layer.borderColor = UIColor.accentColor.cgColor
        
        setStickerBtn.constrainToSuperviewCorner(cornerPosition: .bottomLeft)
        
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
        imageAndStickerPopup.onImageSelected = onImageOrStickerSelected
        imageAndStickerPopup.popupType = .image
        imageAndStickerPopup.show()
    }
    
    @objc func onSetStickerBtnTap() {
        dismissKeyboard()
        imageAndStickerPopup.onImageSelected = onImageOrStickerSelected
        imageAndStickerPopup.popupType = .sticker
        imageAndStickerPopup.show()
    }
    
    func onImageOrStickerSelected() {
        imageAndStickerPopup.hide()
    }
    
    @objc func onAdditionCategoryPickerTap() {
        dismissKeyboard()
        additionCategoryPickerPopup.show()
    }
    
    func onAdditionPopupDismiss() {
        additionCategoryPickerPopup.picker.selectRow(selectedAdditionTypeIndex, inComponent: 0, animated: false)
    }
    
    @objc func onAdditionDateAndTimeInputTap() {
        dismissKeyboard()
        let setDateAndTimeScreenVC = SetDateAndTimeScreenVC()
        setDateAndTimeScreenVC.delegate = self
        present(setDateAndTimeScreenVC, animated: true, completion: nil)
    }
    
    @objc func onAdditionCategorySelection() {
        let selectedValueIndex = additionCategoryPickerPopup.picker.selectedRow(inComponent: 0)
        selectedAdditionTypeIndex = selectedValueIndex
        additionType = taskTypeModel.types[selectedValueIndex]
        let input = additionCategoryPopoverBtn.input as! PopoverBtn
        input.label.text = additionType
        additionCategoryPickerPopup.hide()
    }
    
    func onDateAndTimeSaveBtnTap(selectedTimeStamp: Double) {
        print(selectedTimeStamp)
        self.selectedTimeStamp = selectedTimeStamp
    }
    
    func onTypeSaveBtnTap(id: Int) {
        selectedItemTypeID = id
        saveItem()
    }
    
    func onSaveBtnTap() {
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
        if let textview = additionCategoryPopoverBtn.input as? EditableTextView {
            let description = textview.text ?? ""
            return description
        }
        
        return ""
    }
    
    func saveItem() {
        let item = ItemModel()
        item.name = getItemName()
        item.type = selectedItemTypeID ?? 0
        item.date = selectedTimeStamp ?? 0
        item.item_description = getItemDescription()
        item.image_id = imageAndStickerPopup.selectedImageModelIndex ?? 0
        item.sticker_id = imageAndStickerPopup.selectedStickerModelIndex ?? 0
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
