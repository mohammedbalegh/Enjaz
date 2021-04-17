
import UIKit

class AdditionTypeScreenVC: UIViewController, AdditionTypeScreenCardDelegate {
    
    var chosenCard = 0
        
    lazy var goalCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = ItemType.goal.id
        card.typeImage.image = UIImage(named: "goalIcon")
        card.typeTitle.text = ItemType.getTypeById(id: card.id).localizedName
        card.typeDescription.text = NSLocalizedString("If you have a goal that you want to achieve in a specific field", comment: "")
        return card
    }()
    
    lazy var demahCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = ItemType.demah.id
        card.typeImage.image = UIImage(named: "demahIcon")
        card.typeTitle.text = ItemType.getTypeById(id: card.id).localizedName
        card.typeDescription.text = NSLocalizedString("If you have a habit throughout a specific period", comment: "")
        return card
    }()
    
    lazy var achievementCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = ItemType.achievement.id
        card.typeImage.image = UIImage(named: "achievementIcon")
        card.typeTitle.text = ItemType.getTypeById(id: card.id).localizedName
        card.typeDescription.text = NSLocalizedString("If you have an achievement that you want to complete in a specific time", comment: "")
        return card
    }()
    
    lazy var taskCard: TypeCardBtn = {
        let card = TypeCardBtn()
        card.delegate = self
        card.id = ItemType.task.id
        card.typeImage.image = UIImage(named: "taskIcon")
        card.typeTitle.text = ItemType.getTypeById(id: card.id).localizedName
        card.typeDescription.text = NSLocalizedString("If you have a task that want to complete in a specific time", comment: "")
        return card
    }()
    
    lazy var goalDemahStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [goalCard, demahCard])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution  = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.042
        
        return stackView
    }()
    
    lazy var achievementTaskStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [achievementCard, taskCard])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution  = .fillEqually
        stackView.spacing = LayoutConstants.screenHeight * 0.042
        
        return stackView
    }()
        
    let alertPopup = AlertPopup(hideOnOverlayTap: true)
    
    var selectedTypeId = -1
    
    var delegate: AddItemScreenModalDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainScreenBackgroundColor
                
        setupSubviews()
    }
        
    func setupSubviews() {
        setupGoalDemahStack()
        setupStackAchievementTaskStack()
    }
        
    func setupGoalDemahStack() {
        view.addSubview(goalDemahStack)
                
        NSLayoutConstraint.activate([
            goalDemahStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            goalDemahStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goalDemahStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            goalDemahStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
        ])
    }
    
    func setupStackAchievementTaskStack() {
        view.addSubview(achievementTaskStack)
                
        NSLayoutConstraint.activate([
            achievementTaskStack.topAnchor.constraint(equalTo: goalDemahStack.bottomAnchor, constant: LayoutConstants.screenHeight * 0.03),
            achievementTaskStack.centerXAnchor.constraint(equalTo: goalDemahStack.centerXAnchor),
            achievementTaskStack.widthAnchor.constraint(equalTo: goalDemahStack.widthAnchor),
            achievementTaskStack.heightAnchor.constraint(equalTo: goalDemahStack.heightAnchor),
        ])
    }
        
    func handleCardSelection(cardId selectedCardId: Int) {
        selectedTypeId = selectedCardId
        taskCard.selectedId = selectedCardId
        demahCard.selectedId = selectedCardId
        goalCard.selectedId = selectedCardId
        achievementCard.selectedId = selectedCardId
    }
 
    func resetCardSelection() {
        selectedTypeId = -1
        taskCard.selectedId = -1
        demahCard.selectedId = -1
        goalCard.selectedId = -1
        achievementCard.selectedId = -1
    }
}
