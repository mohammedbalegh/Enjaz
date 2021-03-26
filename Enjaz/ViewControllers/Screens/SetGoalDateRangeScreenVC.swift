import UIKit

class SetGoalDateRangeScreenVC: SetDateAndTimeScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Start and End Date", comment: "")
        calendarView.allowsRangeSelection = true
    }
    
    override func setupSubviews() {
        setupHeader()
        setupCalendarView()
        setupSaveButton()
    }
}
