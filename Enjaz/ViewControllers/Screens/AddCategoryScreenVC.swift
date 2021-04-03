import UIKit
import SPAlert

class AddCategoryScreenVC: UIViewController {

    let setImageBtn = RoundBtn(image: UIImage(named: "imageIcon"), size: LayoutConstants.screenHeight * 0.11)
        
    let imagePickerPopup = ImagePickerPopup(hideOnOverlayTap: true)
    
    lazy var categoryNameTextField: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: .zero)
        
        let fieldName = NSLocalizedString("Category Name", comment: "")
        containerView.fieldName = fieldName
        
        let textField = NewAdditionTextField(fieldName: fieldName)
        
        textField.delegate = self
        
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var categoryDescriptionTextView: NewAdditionInputFieldContainer = {
        let containerView = NewAdditionInputFieldContainer(frame: .zero)
        
        let textView = EditableTextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font = .systemFont(ofSize: 18)
        
        let fieldName = NSLocalizedString("Description", comment: "") + " (\(NSLocalizedString("optional", comment: ""))"
        containerView.fieldName = fieldName
        
        textView.placeholder = fieldName
        
        containerView.input = textView
        
        return containerView
    }()
    
    lazy var textFieldsVerticalStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [categoryNameTextField, categoryDescriptionTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        return stackView
    }()
    
    let saveBtn = PrimaryBtn(label: NSLocalizedString("Save", comment: ""), theme: .blue, size: .large)
    
    var categoryImageId: Int?
        
    var categoryName: String {
        return categoryNameTextField.input?.inputText ?? ""
    }
    
    var categoryDescription: String {
        return categoryDescriptionTextView.input?.inputText ?? ""
    }
    
    var categoryImageSource: String {
        if let categoryImageId = categoryImageId { return imageIdConstants[categoryImageId]! }
        return "defaultCategoryImage"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Add new category", comment: "")
        view.backgroundColor = .mainScreenBackgroundColor
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupSetImageButton()
        setupTextFieldsVerticalStack()
        setupSaveBtn()
    }
    
    func setupSetImageButton() {
        view.addSubview(setImageBtn)
        
        NSLayoutConstraint.activate([
            setImageBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            setImageBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        imagePickerPopup.imageSelectionHandler = handleImageSelection
        
        setImageBtn.addTarget(self, action: #selector(handleSetImageBtnTap), for: .touchUpInside)
    }
    
    func setupTextFieldsVerticalStack() {
        view.addSubview(textFieldsVerticalStack)
        
        let height = textFieldsVerticalStack.calculateHeightBasedOn(arrangedSubviewHeight: LayoutConstants.inputHeight)
        
        NSLayoutConstraint.activate([
            textFieldsVerticalStack.topAnchor.constraint(equalTo: setImageBtn.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
            textFieldsVerticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsVerticalStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            textFieldsVerticalStack.heightAnchor.constraint(equalToConstant: height),
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
    
    // MARK: Event Handlers
    
    @objc func handleSetImageBtnTap() {
        dismissKeyboard()
        imagePickerPopup.present()
    }
    
    
    func handleImageSelection(selectedId: Int) {
        categoryImageId = selectedId
        
        if let imageName = imageIdConstants[selectedId] {
            setImageBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        
        imagePickerPopup.hide()
    }
    
    fileprivate func saveItemCategory() {
        let itemCategory = ItemCategoryModel(name: categoryName, category_description: categoryDescription, imageSource: categoryImageSource, isDefault: false)
        
        RealmManager.saveItemCategory(itemCategory)
    }
    
    @objc func handleSaveBtnTap() {
        guard !categoryName.isEmpty else {
            AlertBottomSheetView.shared.presentAsError(withMessage: NSLocalizedString("Category name must be entered", comment: ""))
            
            return
        }
            
        saveItemCategory()
        
        navigationController?.popViewController(animated: true)
        
        let successMessage = generateSuccessMessage()
        SPAlert.present(title: successMessage, preset: .done)
    }
    
    
    func generateSuccessMessage() -> String {
        if Locale.current.languageCode == "ar" {
            return "تم إضافة المجال بنجاح"
        }
        
        return "Category was added successfully"
    }

}

extension AddCategoryScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
