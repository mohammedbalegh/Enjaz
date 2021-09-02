import UIKit
import RealmSwift

class TreeAchievementsVC: UITableViewController {
    
    var id = 0
    var stages = List<TreeStageModel>()
    
    let doneBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        doneBtn.addTarget(self, action: #selector(doneBtnTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
    }
    
    @objc func doneBtnTapped() {
        print("pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.register(TreeAchievementsCell.self, forCellReuseIdentifier: "treeStageCell")
        stages = RealmManager.treeStagesById(id)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages.count 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "treeStageCell", for: indexPath) as! TreeAchievementsCell

        cell.messageLabel.text = stages[indexPath.row].message
        cell.cellCount.text = "\(stages[indexPath.row].stage)"

        return cell
    }
}
