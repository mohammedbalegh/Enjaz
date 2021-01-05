import UIKit

class SelectGoalTypeScreenVC: ScreenNavigatorWithDynamicDataTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .rootTabBarScreensBackgroundColor
        screenNavigatorCellModels = [
            ScreenNavigatorCellModel(image: UIImage(named: "religionSideIcon"), label: "الجانب الديني", subLabel: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),
            ScreenNavigatorCellModel(image: UIImage(named: "scientificSideIcon"), label: "الجانب العلمي", subLabel: "الاهداف المرتبطة بالعلم و التعلم و القراءة و الدورات و تنمية العقل"),
            ScreenNavigatorCellModel(image: UIImage(named: "healthSideIcon"), label: "الجانب الصحي", subLabel: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
            ScreenNavigatorCellModel(image: UIImage(named: "socialSideIcon"), label: "الجانب الاجتماعي", subLabel: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),
            ScreenNavigatorCellModel(image: UIImage(named: "careerSideIcon"), label: "الجانب المهني", subLabel: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),
            ScreenNavigatorCellModel(image: UIImage(named: "personalSideIcon"), label: "الجانب الشخصي", subLabel: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),
            ScreenNavigatorCellModel(image: UIImage(named: "financialSideIcon"), label: "الجانب المالي", subLabel: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),
        ]
                
        tableViewTitle = "اختر مجال الهدف"
        targetViewController = AddGoalScreenVC()
        tableView.reloadData()        
    }
    
}
