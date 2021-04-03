import UIKit

class AddGoalScreenVC: NewAdditionScreenVC {
        
    override func viewDidLoad() {
        itemCategory = id
        itemType = ItemType.goal.id
        
        super.viewDidLoad()
    }
        
    // MARK: Tools
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        return [additionNameTextField, repeatSwitchView, additionDateAndTimeInput]
    }
}
