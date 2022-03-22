
import UIKit

class MajorGoalsScreenVC: KeyboardHandlingViewController{
    
    let defaults = UserDefaults.standard
    var categoryId: Int = 0
    
    var submitChangesButton: UIButton = {
        var button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named:"checkButton"), for: .normal)
        button.addTarget(self, action: #selector(submitNoteChanges), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let majorGoalView: MajorGoalsView = {
        let view = MajorGoalsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        title = "Major goals".localized
        
        setupSubviews()
        getGoalCategory()
    }
    
    func setupSubviews() {
        setupMajorGoalView()
        setupSubmitNoteChanges()
    }
    
    func getGoalCategory() {
        let category = RealmManager.retrieveItemCategoryById(categoryId)
        majorGoalView.badge.badgeTitle.text = category?.localized_name
        majorGoalView.majorDescription.text = category?.localized_description
    }
    
    @objc func submitNoteChanges() {
        defaults.set(majorGoalView.textField.text, forKey: "MajorGoalOfCategory\(categoryId)")
        navigationController?.popViewController(animated: true)
    }
    
    func setupSubmitNoteChanges() {
        view.addSubview(submitChangesButton)
        
        let size = LayoutConstants.screenWidth * 0.151
        
        NSLayoutConstraint.activate([
            submitChangesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.06)),
            submitChangesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitChangesButton.widthAnchor.constraint(equalToConstant: size),
            submitChangesButton.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupMajorGoalView() {
        view.addSubview(majorGoalView)
        
        majorGoalView.textField.text = defaults.string(forKey: "MajorGoalOfCategory\(categoryId)")
        majorGoalView.textField.textColor = .highContrastText
        
        NSLayoutConstraint.activate([
            majorGoalView.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.164),
            majorGoalView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.885),
            majorGoalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            majorGoalView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.47)
        
        ])
        
    }
    
}
