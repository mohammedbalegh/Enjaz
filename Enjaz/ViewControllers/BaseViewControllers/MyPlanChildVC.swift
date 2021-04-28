import UIKit

class MyPlanChildVC: UIViewController {
	
	let searchVC = SearchControllerVC()
	
	lazy var searchController: UISearchController = {
		let search = UISearchController(searchResultsController: searchVC)
		search.delegate = self
		return search
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchController.searchResultsUpdater = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
}

extension MyPlanChildVC:  UISearchResultsUpdating, UISearchControllerDelegate {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		
		let searchItems = RealmManager.retrieveItemsBySearch(contains: text)
		
		searchVC.itemsTableView.items = searchItems
	}
	
}
