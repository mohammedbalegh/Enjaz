import UIKit

class NewAdditionScreenVC: UIViewController {
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
	var additionNameTextField = AddTaskTextField(fieldName: "اسم الإضافة")
	lazy var additionTypeTextField: AddTaskTextField = {
		let textField = AddTaskTextField(fieldName: "مجال الإضافة")
		
		textField.delegate = self
		textField.addTarget(self, action: #selector(onAdditionTypePickerTap), for: .allTouchEvents)
		
		return textField
	}()
	lazy var additionTypePickerPopup: PickerPopup = {
		let pickerPopup = PickerPopup(hideOnOverlayTap: true)
		
		pickerPopup.picker.delegate = self
		pickerPopup.picker.dataSource = self
		
		pickerPopup.selectBtn.addTarget(self, action: #selector(onAdditionTypeSelection), for: .touchUpInside)
		pickerPopup.onPopupDismiss = self.onAdditionPopupDismiss
		
		return pickerPopup
	}()
	lazy var additionDateAndTimeInput: AddTaskTextField = {
		let textField = AddTaskTextField(fieldName: "التاريخ و الوقت")
		
		textField.delegate = self
		textField.addTarget(self, action: #selector(onAdditionDateAndTimeInputTap), for: .allTouchEvents)
		
		return textField
	}()
	var additionDescriptionTextField = AddTaskTextField(fieldName: "الوصف", height: 160)
	lazy var textFieldsVSV: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [additionNameTextField, additionTypeTextField, additionDateAndTimeInput, additionDescriptionTextField])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.spacing = 40
		
		return stackView
	}()
	let taskTypeModel = TaskType()
	
	// MARK: State
	
	var selectedAdditionTypeIndex = 0
	var additionType = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .rootTabBarScreensBackgroundColor
		dismissKeyboardOnTextFieldBlur()
		setupSubviews()
    }
	
	func setupSubviews() {
		setupScrollView()
		setupSetImageButton()
		setupSetStickerButton()
		setupTextFieldsVSV()
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
			textFieldsVSV.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
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
	
	@objc func onAdditionTypePickerTap() {
		dismissKeyboard()
		additionTypePickerPopup.show()
	}
	
	func onAdditionPopupDismiss() {
		additionTypePickerPopup.picker.selectRow(selectedAdditionTypeIndex, inComponent: 0, animated: false)
	}
	
	@objc func onAdditionDateAndTimeInputTap() {
		present(SetDateAndTimeScreenVC(), animated: true, completion: nil)
	}
	
	@objc func onAdditionTypeSelection() {
		let selectedValueIndex = additionTypePickerPopup.picker.selectedRow(inComponent: 0)
		selectedAdditionTypeIndex = selectedValueIndex
		additionType = taskTypeModel.types[selectedValueIndex]
		additionTypeTextField.text = additionType
		additionTypePickerPopup.hide()
	}
	
	func onSaveBtnTap() {
		print("save button tapped")
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
