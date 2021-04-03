import UIKit

class AddGoalScreenVC: NewAdditionScreenVC {
    
    var category: ItemCategoryModel?
    
    override func viewDidLoad() {
        guard let category = category else { fatalError("Invalid category") }
        
        itemCategory = category.id
        itemType = ItemType.goal.id
        
        super.viewDidLoad()
    }
        
    // MARK: Tools
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        return [additionNameTextField, repeatSwitchView, additionDateAndTimeInput]
    }
}
