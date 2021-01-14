import UIKit

class SetGoalDateRangeScreenVC: SetDateAndTimeScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        header.titleLabel.text = "تاريخ البداية و النهاية"
        calendarView.allowsRangeSelection = true
    }
    
    override func setupSubviews() {
        setupHeader()
        setPopoverBtnsDefaultLabels()
        setupCalendarView()
        setupSaveButton()
    }
}
