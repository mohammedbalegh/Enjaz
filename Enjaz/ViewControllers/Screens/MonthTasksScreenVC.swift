import UIKit

class MonthTasksScreenVC: MonthItemsScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsType = ItemType.task.id
    }
    
    override func setItemCardViewsTitles() {
        dayItemsView.title = NSLocalizedString("Today's Tasks", comment: "")
        weekItemsView.title = NSLocalizedString("Week's Tasks", comment: "")
        monthItemsView.title = NSLocalizedString("Month's Tasks", comment: "")
        completedItemsView.title = NSLocalizedString("Completed Tasks", comment: "")
        
        dayItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
        weekItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
        monthItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
        completedItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
    }
    
}
