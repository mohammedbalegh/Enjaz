import UIKit
import SPAlert

class AddCategoryScreenVC: KeyboardHandlingViewController {

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
		popup.imageCellModels = RealmManager.retrieveDefaultItemImages().map { $0.image_source }
		popup.delegate = self
		return popup
	}()
    
    lazy var categoryNameTextField: InputFieldContainer = {
        let fieldName = "Category Name".localized
		
        let textField = InputFieldContainerTextField()
        textField.placeholder = fieldName
        textField.delegate = self
		
		let containerView = InputFieldContainer(frame: .zero)
		containerView.fieldName = fieldName
        containerView.input = textField
        
        return containerView
    }()
    
    lazy var categoryDescriptionTextView: InputFieldContainer = {
        let fieldName = "Description".localized + " (\("optional".localized))"
		
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
    
    let saveBtn = PrimaryBtn(label: "Save".localized, theme: .blue, size: .large)
    
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
        title = "Add new category".localized
        view.backgroundColor = .background
        
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
			setImageBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24),
			setImageBtn.heightAnchor.constraint(equalTo: setImageBtn.widthAnchor),
        ])
		
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
        imagePickerPopup.present(animated: true)
    }
        
    @objc func handleSaveBtnTap() {
        guard !categoryName.isEmpty else {
            AlertBottomSheetView.shared.presentAsError(withMessage: "Category name must be entered".localized)
            
            return
        }
            
        saveItemCategory()
        
        navigationController?.popViewController(animated: true)
        
        let successMessage = String(format: "%@ was added successfully".localized, "category".localized)
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
		imagePickerPopup.dismiss(animated: true)
	}
	
	func ImagePickerPopup(_ itemImagePickerPopup: ItemImagePickerPopup, didSelectImageSource sourceType: UIImagePickerController.SourceType) {
		itemImagePickerPopup.dismiss(animated: true)
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
		
		imagePickerPopup.dismiss(animated: true)
		nonDefaultItemImage = ItemImageModel(imageSource: imageData, isDefault: false, isSelectable: false)
		categoryImageId = nonDefaultItemImage!.id
		setImageBtn.setImage(UIImage.getImageFrom(imageData), for: .normal)
	}
}
