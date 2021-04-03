import UIKit

class AddNoteScreenVC: UIViewController {
    
    var selectedCategory: String?
    var selectedNoteCategoryIndex: Int = 0
    var itemCategoryModels: [ItemCategoryModel] = []
    
    var submitNewNoteBtn: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "checkButton"), for: .normal)
        button.addTarget(self, action: #selector(handlesSubmitNewNoteBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var noteCategoryButton: NoteCategoryPickerView = {
        var button = NoteCategoryPickerView()
        button.noteCategoryBtn.setTitle(NSLocalizedString("Note category", comment: ""), for: .normal)
        button.noteCategoryBtn.addTarget(self, action: #selector(handleNoteCategoryButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleTextField: NoteTitleTextField = {
        var textField = NoteTitleTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var noteTextField: EditableTextView = {
        var textView = EditableTextView(frame: .zero)
        textView.placeholder = NSLocalizedString("Write whats on your mind", comment: "")
        textView.layer.borderWidth = 0.4
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.borderColor.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var notesCategoryPicker: PickerBottomSheetView = {
        let pickerPopup = PickerBottomSheetView()
        
        pickerPopup.picker.delegate = self
        pickerPopup.picker.dataSource = self
        
        pickerPopup.dismissalHandler = handleNotesCategoryPickerDismissal
        pickerPopup.selectBtn.addTarget(self, action: #selector(handleNoteCategorySelection), for: .touchUpInside)
        
        return pickerPopup
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Add Note", comment: "")
        view.backgroundColor = .mainScreenBackgroundColor
        self.hideKeyboardWhenTappedAround()
        setupSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemCategoryModels = RealmManager.retrieveItemCategories()
    }
    
    func setupSubView() {
        setupTitleTextField()
        setupNoteCategoryButton()
        setupNoteTextField()
        setupSubmitNewNoteBtn()
    }
    
    @objc func handlesSubmitNewNoteBtn() {
        let alertPopup = AlertPopup(hideOnOverlayTap: true)
        if titleTextField.textField.text == "" {
            alertPopup.presentAsError(withMessage: NSLocalizedString("Note title Can't be empty", comment: ""))
        } else if noteCategoryButton.noteCategoryBtn.currentTitle == NSLocalizedString("Note category", comment: "")  {
            alertPopup.presentAsError(withMessage: NSLocalizedString("Note category can't be empty", comment:  ""))
        }  else if noteTextField.text == NSLocalizedString("Write whats on your mind", comment: "") {
            alertPopup.presentAsError(withMessage: NSLocalizedString("Please write whats on your mind", comment: ""))
        } else  {
            let aspect = PersonalAspectsModel()
            
            aspect.title = titleTextField.textField.text ?? ""
            aspect.brief_or_date = getCurrentDate()
            aspect.image_source = "noteDefaultImage"
            aspect.badge_image_source = "noteDefaultBadge"
            aspect.category.value = notesCategoryPicker.picker.selectedRow(inComponent: 0)
            aspect.aspect_description = getCurrentDate()
            aspect.aspect_text = noteTextField.text
            
            RealmManager.saveAspect(aspect)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleNotesCategoryPickerDismissal() {
        notesCategoryPicker.picker.selectRow(selectedNoteCategoryIndex, inComponent: 0, animated: false)
    }
    
    @objc func handleNoteCategorySelection() {
        selectedNoteCategoryIndex = notesCategoryPicker.picker.selectedRow(inComponent: 0)
        selectedCategory = itemCategoryModels[selectedNoteCategoryIndex].localized_name
        noteCategoryButton.noteCategoryBtn.setTitleColor(.black, for: .normal)
        noteCategoryButton.noteCategoryBtn.setTitle(selectedCategory, for: .normal)
        notesCategoryPicker.dismiss(animated: true)
    }
    
    @objc func handleNoteCategoryButtonTap() {
        notesCategoryPicker.present(animated: true)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "h:m a   MM/dd/yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func setupSubmitNewNoteBtn() {
        view.addSubview(submitNewNoteBtn)
        
        let size = LayoutConstants.screenWidth * 0.151
        
        NSLayoutConstraint.activate([
            submitNewNoteBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.06)),
            submitNewNoteBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitNewNoteBtn.widthAnchor.constraint(equalToConstant: size),
            submitNewNoteBtn.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupNoteTextField() {
        view.addSubview(noteTextField)
        
        NSLayoutConstraint.activate([
            noteTextField.topAnchor.constraint(equalTo: noteCategoryButton.bottomAnchor, constant: LayoutConstants.screenHeight * 0.037),
            noteTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noteTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.557),
            noteTextField.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.885)
        ])
    }
    
    func setupTitleTextField() {
        view.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.055),
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.173),
            titleTextField.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.662),
            titleTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0232)
        ])
        titleTextField.layoutIfNeeded()
        
        titleTextField.addBottomBorder(withColor: .gray, andWidth: 0.2)
    }
    
    func setupNoteCategoryButton() {
        view.addSubview(noteCategoryButton)
        
        NSLayoutConstraint.activate([
            noteCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.055),
            noteCategoryButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: LayoutConstants.screenHeight * 0.0341),
            noteCategoryButton.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.662),
            noteCategoryButton.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.0232)
        ])
        noteCategoryButton.layoutIfNeeded()
        
        noteCategoryButton.addBottomBorder(withColor: .gray, andWidth: 0.2)
    }
}

extension AddNoteScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //TODO: Note Deletion
    
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
