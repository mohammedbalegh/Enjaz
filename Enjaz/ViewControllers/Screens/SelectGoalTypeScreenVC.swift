import UIKit

class SelectGoalTypeScreenVC: ScreenNavigatorWithDynamicDataTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .rootTabBarScreensBackgroundColor
        screenNavigatorCellModels = [
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
        ]
                
        tableViewTitle = "اختر مجال الهدف"
        targetViewController = AddGoalScreenVC()
        tableView.reloadData()        
    }
    
}
