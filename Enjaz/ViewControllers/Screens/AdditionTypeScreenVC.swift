
import UIKit

class AdditionTypeScreenVC: UIViewController, AdditionTypeScreenCardDelegate {
    
    var chosenCard = 0
    
    lazy var taskCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 0
        card.typeImage.image = UIImage(named: "taskIcon")
        card.typeTitle.text = "مهمة"
        card.typeDescription.text = "ان كان لديك مهمة تريد انجازها خلال وقت معين"
        return card
    }()
    
    lazy var demahCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 1
        card.typeImage.image = UIImage(named: "demahIcon")
        card.typeTitle.text = "ديمة"
        card.typeDescription.text = "اذا كان لديك عادة متكررة خلال فترة معينة"
        return card
    }()
    
    lazy var achievementCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 2
        card.typeImage.image = UIImage(named: "achievementIcon")
        card.typeTitle.text = "إنجاز"
        card.typeDescription.text = "ان كان لديك أنجاز تريد تحقيقه خلال وقت معين"
        return card
    }()
    
    lazy var goalCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = 3
        card.typeImage.image = UIImage(named: "goalIcon")
        card.typeTitle.text = "هدف"
        card.typeDescription.text = "ان كان لديك هدف في مجال معين تريد تحقيقه "
        return card
    }()
    
    lazy var stackTaskDemah: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskCard, demahCard])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution  = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.042
        
        return stackView
    }()
    
    lazy var stackAchievementGoal: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution  = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.042
        
        stackView.addArrangedSubview(achievementCard)
        stackView.addArrangedSubview(goalCard)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let saveBtn = PrimaryBtn(label: "حفظ", theme: .blue)
    
    var selectedTypeId = -1
    
    var delegate: NewAdditionScreenModalDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupStackTaskDemah()
        setupStackAchievementGoal()
        setupSaveBtn()
    }
    
    func setupStackTaskDemah() {
        view.addSubview(stackTaskDemah)
        
        let width = LayoutConstants.screenWidth * 0.4
        
        NSLayoutConstraint.activate([
            stackTaskDemah.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (LayoutConstants.screenWidth * 0.05)),
            stackTaskDemah.widthAnchor.constraint(equalToConstant: width),
            stackTaskDemah.heightAnchor.constraint(equalToConstant: width * 3),
            stackTaskDemah.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.123)
        ])
    }
    
    func setupStackAchievementGoal() {
        view.addSubview(stackAchievementGoal)
        
        let width = LayoutConstants.screenWidth * 0.4
        
        NSLayoutConstraint.activate([
            stackAchievementGoal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(LayoutConstants.screenWidth * 0.05)),
            stackAchievementGoal.widthAnchor.constraint(equalToConstant: width),
            stackAchievementGoal.heightAnchor.constraint(equalToConstant: width * 3),
            stackAchievementGoal.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.123)
        ])
    }
    
    func setupSaveBtn() {
        view.addSubview(saveBtn)
        
        let width = LayoutConstants.screenWidth * 0.86
        
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.04)),
            saveBtn.widthAnchor.constraint(equalToConstant: width),
            saveBtn.heightAnchor.constraint(equalToConstant: width * 0.182)
        ])
        
        saveBtn.addTarget(self, action: #selector(onSaveBtnTap), for: .touchUpInside)
    }
    
    func onCardSelect(cardId selectedCardId: Int) {
        selectedTypeId = selectedCardId
        taskCard.selectedId = selectedCardId
        demahCard.selectedId = selectedCardId
        goalCard.selectedId = selectedCardId
        achievementCard.selectedId = selectedCardId
    }
    
    func showDateInPastAlert() {
        let alert = UIAlertController(title: "خطأ", message: "لم يتم اختيار نوع", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func onSaveBtnTap() {
        if selectedTypeId == -1 {
            showDateInPastAlert()
            
            return
        }
        delegate?.onTypeSaveBtnTap(id: selectedTypeId)
        dismiss(animated: true)
    }
    
}
