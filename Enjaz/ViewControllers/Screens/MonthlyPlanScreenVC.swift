
import UIKit

class MonthlyPlanScreenVC: MenuBarNavigationVC {
    
    let searchVC = SearchControllerVC()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: searchVC)
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        
        searchController.searchResultsUpdater = self
        
        menuItems = [
            NSLocalizedString("Tasks", comment: ""),
            NSLocalizedString("Demahs", comment: ""),
            NSLocalizedString("Achievements", comment: ""),
        ]
        
        controllerViews = [MonthTasksScreenVC(), MonthDemahsScreenVC(), AchievementsScreenVC()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.searchController = searchController
        tabBarController?.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension MonthlyPlanScreenVC:  UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let searchItems = RealmManager.retrieveItemsBySearch(contains: text)
        
        searchVC.itemsTableView.items = searchItems
        searchVC.itemsTableView.reloadData()
        print(searchItems.count)
    }
}
