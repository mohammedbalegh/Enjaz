
import UIKit

class MenuBarNavigationVC: UIViewController {
	
	var initialized = false
	var showSmallTabBar = false
	
    var menuItems: [String] = [] {
        didSet {
            tabMenu.reloadData()
        }
    }
	
    var viewControllers: [UIViewController] = [] {
        didSet {
            tabMenu.reloadData()
        }
    }
    
    fileprivate var currentViewController: UIViewController?
    
	lazy var tabMenu: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let collectionViewWidth = view.frame.width * 0.94
		let collectionViewHeight: CGFloat = 43
		let height: CGFloat = showSmallTabBar ? 25 : collectionViewHeight
		layout.itemSize = CGSize(width: collectionViewWidth / CGFloat(menuItems.count) - 8, height: height)
		layout.scrollDirection = .horizontal
		
		let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: collectionViewWidth, height: collectionViewHeight), collectionViewLayout: layout)
		collectionView.backgroundColor = .clear
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(TabMenuCell.self, forCellWithReuseIdentifier: "cell")

		return collectionView
	}()
    
    let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
		if !initialized {
			selectFirstCell()
			initialized = true
		}
    }
	
    func selectFirstCell() {
		let firstCellIndexPath = IndexPath(row: 0, section: 0)
		tabMenu.selectItem(at: firstCellIndexPath, animated: false, scrollPosition: .left)
		collectionView(tabMenu, didSelectItemAt: firstCellIndexPath)
    }
	
    func presentController(_ controller: UIViewController) {
        guard controller != currentViewController else { return }
		
		controller.navigationItem.titleView = tabMenu
		let presentedNavigationController = UINavigationController(rootViewController: controller)
		
		// Remove the bottom border of the navigationBar
		presentedNavigationController.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground"), for: .default)
		presentedNavigationController.navigationBar.shadowImage = UIImage()
		
		transition(to: presentedNavigationController)
        currentViewController = controller
    }
	
	func transition(to toVC: UIViewController) {
		if let fromVC = children.first {
			transitionWithAnimation(fromVC: fromVC, toVC: toVC)
		} else {
			addWithoutAnimation(child: toVC)
		}
	}
	
	func addWithoutAnimation(child toVC: UIViewController) {
		addChild(toVC)
		view.addSubview(toVC.view)
		toVC.view.frame = view.bounds
		toVC.didMove(toParent: self)
	}
	
	func transitionWithAnimation(fromVC: UIViewController, toVC: UIViewController) {
		addChild(toVC)
		toVC.view.frame = view.bounds
		
		fromVC.willMove(toParent: nil)
		
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue, forKey:kCATransactionDisableActions)
		
		transition(
			from: fromVC,
			to: toVC,
			duration: 0,
			options: [.transitionCrossDissolve],
			animations: nil) { _ in
			fromVC.removeFromParent()
			toVC.didMove(toParent: self)
		}
		
		CATransaction.commit()
	}
    
}

extension MenuBarNavigationVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return menuItems.count
	}
	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TabMenuCell
        cell.label.text = menuItems[indexPath.row]
        return cell
    }
	
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentController(viewControllers[indexPath.row])
    }
    
}
