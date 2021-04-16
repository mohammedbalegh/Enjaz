import UIKit
import SPAlert

class AddCategoryScreenVC: KeyboardHandlingViewController {

    let setImageBtn = RoundBtn(image: UIImage(named: "imageIcon"), size: LayoutConstants.screenHeight * 0.11)
        
	lazy var imagePickerPopup: ItemImagePickerPopup = {
		let popup = ItemImagePickerPopup(hideOnOverlayTap: true)
		popup.imageCellModels = RealmManager.retrieveItemImages().map { $0.image_source }
		popup.delegate = self
		return popup
	}()
    
    lazy var categoryNameTextField: InputFieldContainer = {
        let fieldName = NSLocalizedString("Category Name", comment: "")
		
        let textField = InputFieldContainerTextField()
        textField.placeholder = fieldName
        textField.delegate = self
		
		let containerView = InputFieldContainer(frame: .zero)
		containerView.fieldName = fieldName
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var categoryDescriptionTextView: InputFieldContainer = {
        let fieldName = NSLocalizedString("Description", comment: "") + " (\(NSLocalizedString("optional", comment: "")))"
		
		let textField = InputFieldContainerTextField()
		textField.placeholder = fieldName
		textField.delegate = self
		
		let containerView = InputFieldContainer(frame: .zero)
        containerView.fieldName = fieldName
                
        containerView.input = textField
        
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
    
	var nonDefaultItemImage: ItemImageModel?
	
    var categoryImageId: Int?
	
    var categoryName: String {
        return categoryNameTextField.input?.inputText ?? ""
    }
    
    var categoryDescription: String {
        return categoryDescriptionTextView.input?.inputText ?? ""
    }
    
    var categoryImageSource: String {
		if let itemImage = nonDefaultItemImage { return itemImage.image_source }
        if let categoryImageId = categoryImageId { return RealmManager.retrieveItemImageSourceById(categoryImageId)! }
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
        
    @objc func handleSaveBtnTap() {
        guard !categoryName.isEmpty else {
            AlertBottomSheetView.shared.presentAsError(withMessage: NSLocalizedString("Category name must be entered", comment: ""))
            
            return
        }
            
        saveItemCategory()
        
        navigationController?.popViewController(animated: true)
        
        let successMessage = String.generateAdditionSuccessMessage(type: NSLocalizedString("category", comment: ""))
        SPAlert.present(title: successMessage, preset: .done)
    }
	
	func saveItemCategory() {
		if let itemImage = nonDefaultItemImage {
			RealmManager.saveItemImage(itemImage)
		}
		
		let itemCategory = ItemCategoryModel(name: categoryName, category_description: categoryDescription, imageSource: categoryImageSource, isDefault: false)
		
		RealmManager.saveItemCategory(itemCategory)
	}
}

extension AddCategoryScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension AddCategoryScreenVC: ItemImagePickerPopupDelegate {
	func ImagePickerPopup(_ itemImagePickerPopup: ItemImagePickerPopup, didSelectImage imageId: Int) {
		nonDefaultItemImage = nil
		categoryImageId = imageId
		setImageBtn.setImage(UIImage.getImageFrom(categoryImageSource), for: .normal)
		imagePickerPopup.dismiss()
	}
	
	func ImagePickerPopup(_ itemImagePickerPopup: ItemImagePickerPopup, didSelectImageSource sourceType: UIImagePickerController.SourceType) {
		itemImagePickerPopup.dismiss()
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = sourceType
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		present(imagePickerController, animated: true)
	}
}

extension AddCategoryScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		guard let image = info[.editedImage] as? UIImage else { return }
		guard let imageData = image.scalePreservingAspectRatio(targetSize: CGSize(width: 132, height: 125)).toBase64() else { return }
				
		nonDefaultItemImage = ItemImageModel(imageSource: imageData, isDefault: false)
		categoryImageId = nonDefaultItemImage!.id
		setImageBtn.setImage(UIImage.getImageFrom(imageData), for: .normal)
	}
}
