
import UIKit

class GoalsBankTableView: UITableView{
    
    var goals = ["الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي","الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي","الحصول علي 97% في دراستي","المداومة علي الركض صباحا","قراءة كتاب عن احد الفنون","زيارة ذوي القربي","المداومة علي اذكار الصباح و المساء","تلاوة 5 صفحات من القرآن يوميا"]
    
}

extension GoalsBankTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsTableCell") as! GoalsTableCell
        cell.cellCount.text = "\(indexPath.row + 1)"
        cell.goalLabel.text = "\(goals[indexPath.row])"
        return cell
    }
    
}
