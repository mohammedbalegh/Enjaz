import UIKit

class MonthDemahsScreenVC: MonthItemsScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsType = 1
    }
    
    override func setItemCardViewsTitles() {
        dayItemsView.title = NSLocalizedString("Today's Demahs", comment: "")
        weekItemsView.title = NSLocalizedString("Week's Demahs", comment: "")
        monthItemsView.title = NSLocalizedString("Month's Demahs", comment: "")
        completedItemsView.title = NSLocalizedString("Completed Demahs", comment: "")
        
        dayItemsView.noCardsMessage = NSLocalizedString("No demahs", comment: "")
        weekItemsView.noCardsMessage = NSLocalizedString("No demahs", comment: "")
        monthItemsView.noCardsMessage = NSLocalizedString("No demahs", comment: "")
        completedItemsView.noCardsMessage = NSLocalizedString("No demahs", comment: "")
    }
    
}
