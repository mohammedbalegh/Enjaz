import UIKit

class AddGoalScreenVC: NewAdditionScreenVC {
    
    let saveBtn = PrimaryBtn(label: "حفظ", theme: .blue, size: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "إضافة هدف"
        
        itemCategory = id
        itemType = 3
        additionDateAndTimeInput.fieldName = "التاريخ"
        additionDateAndTimeInput.input?.inputText = "التاريخ (من - إلى)"
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        setupSaveBtn()
    }
    
    func setupSaveBtn() {
        view.addSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        saveBtn.addTarget(self, action: #selector(onSaveBtnTap), for: .touchUpInside)
    }
    
    // MARK: Event Handlers
    
    override func onAdditionDateAndTimeInputTap() {
        dismissKeyboard()
        let setDateAndTimeScreenVC = SetDateAndTimeScreenVC()
        setDateAndTimeScreenVC.delegate = self
        present(setDateAndTimeScreenVC, animated: true, completion: nil)
    }
    
    override func onSaveBtnTap() {
        let nonProvidedRequiredFieldNames = getNonProvidedRequiredFieldNames()
        
        if !nonProvidedRequiredFieldNames.isEmpty {
            let nonProvidedRequiredFieldNamesAsSentence = nonProvidedRequiredFieldNames.joinAsSentence(languageIsArabic: true)
            alertPopup.showAsError(withMessage: "يجب ادخال \(nonProvidedRequiredFieldNamesAsSentence)")
            return
        }
        
        saveItem()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Tools
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        return [additionNameTextField, additionDateAndTimeInput]
    }
}
