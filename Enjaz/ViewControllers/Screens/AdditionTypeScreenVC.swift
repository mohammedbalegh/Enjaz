
import UIKit

class AdditionTypeScreenVC: UIViewController, AdditionTypeScreenCardDelegate {
    
    var chosenCard = 0
    
    lazy var header: ModalHeader = {
        let header = ModalHeader(frame: .zero)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        header.titleLabel.text = "اختر نوع الإضافة"
        header.dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        return header
    }()
    
    lazy var taskCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 0
        card.typeImage.image = UIImage(named: "taskIcon")
        card.typeTitle.text = ItemTypeConstants[card.id] ?? ""
        card.typeDescription.text = "ان كان لديك مهمة تريد انجازها خلال وقت معين"
        return card
    }()
    
    lazy var demahCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 1
        card.typeImage.image = UIImage(named: "demahIcon")
        card.typeTitle.text = ItemTypeConstants[card.id] ?? ""
        card.typeDescription.text = "اذا كان لديك عادة متكررة خلال فترة معينة"
        return card
    }()
    
    lazy var achievementCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 2
        card.typeImage.image = UIImage(named: "achievementIcon")
        card.typeTitle.text = ItemTypeConstants[card.id] ?? ""
        card.typeDescription.text = "ان كان لديك أنجاز تريد تحقيقه خلال وقت معين"
        return card
    }()
    
    lazy var goalCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 3
        card.typeImage.image = UIImage(named: "goalIcon")
        card.typeTitle.text = ItemTypeConstants[card.id] ?? ""
        card.typeDescription.text = "ان كان لديك هدف في مجال معين تريد تحقيقه "
        return card
    }()
    
    lazy var stackTaskDemah: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskCard, demahCard])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution  = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.042
        
        return stackView
    }()
    
    lazy var stackAchievementGoal: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [achievementCard, goalCard])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution  = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.042
        
        return stackView
    }()
    
    let saveBtn = PrimaryBtn(label: "حفظ", theme: .blue, size: .large)
    
    let alertPopup = AlertPopup(hideOnOverlayTap: true)
    
    var selectedTypeId = -1
    
    var delegate: NewAdditionScreenModalDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupHeader()
        setupStackTaskDemah()
        setupStackAchievementGoal()
        setupSaveBtn()
    }
    
    func setupHeader() {
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setupStackTaskDemah() {
        view.addSubview(stackTaskDemah)
                
        NSLayoutConstraint.activate([
            stackTaskDemah.topAnchor.constraint(equalTo: header.bottomAnchor, constant: LayoutConstants.screenHeight * 0.1),
            stackTaskDemah.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackTaskDemah.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            stackTaskDemah.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
        ])
    }
    
    func setupStackAchievementGoal() {
        view.addSubview(stackAchievementGoal)
                
        NSLayoutConstraint.activate([
            stackAchievementGoal.topAnchor.constraint(equalTo: stackTaskDemah.bottomAnchor, constant: LayoutConstants.screenHeight * 0.03),
            stackAchievementGoal.centerXAnchor.constraint(equalTo: stackTaskDemah.centerXAnchor),
            stackAchievementGoal.widthAnchor.constraint(equalTo: stackTaskDemah.widthAnchor),
            stackAchievementGoal.heightAnchor.constraint(equalTo: stackTaskDemah.heightAnchor),
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
    
    func handleCardSelection(cardId selectedCardId: Int) {
        selectedTypeId = selectedCardId
        taskCard.selectedId = selectedCardId
        demahCard.selectedId = selectedCardId
        goalCard.selectedId = selectedCardId
        achievementCard.selectedId = selectedCardId
    }
    
    
    @objc func handleSaveBtnTap() {
        if selectedTypeId == -1 {
            alertPopup.showAsError(withMessage: "لم يتم اختيار نوع")
            return
        }
        
        delegate?.handleTypeSaveBtnTap(id: selectedTypeId)
        dismissModal()
    }
    
    @objc func dismissModal() {
        dismiss(animated: true)
    }
}
