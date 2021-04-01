
import UIKit

class MenuBarNavigationVC: UIViewController {

    enum selectStatus {
        case selected
        case deSelected
    }
    
    var initialized = false
    
    var menuItems: [String] = [] {
        didSet {
            topMenu.reloadData()
        }
    }
    var controllerViews: [UIViewController] = [] {
        didSet {
            topMenu.reloadData()
        }
    }
    
    fileprivate var currentViewController: UIViewController?
    
    lazy var topMenu: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.semanticContentAttribute = .forceRightToLeft
        cv.register(TopMenuCell.self, forCellWithReuseIdentifier: "topMenuCell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        topMenu.delegate = self
        topMenu.dataSource = self
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectFirstCell()
    }
        
    func selectFirstCell() {
        if initialized == false {
            presentController(controllerViews[0])
            getSelectedCell(at: [0,0], selectCell: .selected)
            initialized = true
        }
    }
    
    func setupSubviews() {
        setTopMenu()
    }
    
    func presentController(_ controller: UIViewController) {
        if controller == currentViewController { return }
        removeCurrentViewController()
        addChild(controller)
        view.addSubview(controller.view)
        currentViewController = controller
        setupChildViewController()
        controller.didMove(toParent: self)
    }
    
    func removeCurrentViewController() {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
    }
    
    func getSelectedCell(at indexPath: IndexPath, selectCell: selectStatus) {
        guard let cell = topMenu.cellForItem(at: indexPath) as? TopMenuCell else {
            return
        }
        if selectCell == .selected {
            cell.label.textColor = .accentColor
            cell.addBottomBorder(withColor: .accentColor, andWidth: 2)
        } else {
            cell.label.textColor = .lightGray
            cell.addBottomBorder(withColor: .mainScreenBackgroundColor, andWidth: 2)
        }
    }
    
    func setupChildViewController() {
        
        currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentViewController!.view.topAnchor.constraint(equalTo: topMenu.bottomAnchor),
            currentViewController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentViewController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentViewController!.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setTopMenu() {
        
        container.addSubview(topMenu)
        topMenu.fillSuperView()
        
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.heightAnchor.constraint(equalToConstant: 30),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        container.layoutIfNeeded()
        
        container.addBottomBorder(withColor: .lightGray, andWidth: 0.5)
    }
    
}

extension MenuBarNavigationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topMenuCell", for: indexPath) as! TopMenuCell
        cell.label.text = menuItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / CGFloat(menuItems.count)) - 8, height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for row in 0..<menuItems.count {
            getSelectedCell(at: [0,row], selectCell: .deSelected)
        }
        
        getSelectedCell(at: indexPath, selectCell: .selected)
        presentController(controllerViews[indexPath.row])
    }
    
}
