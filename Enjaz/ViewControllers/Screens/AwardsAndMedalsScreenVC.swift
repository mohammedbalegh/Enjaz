import UIKit

class AwardsAndMedalsScreenVC: UIViewController {
    
    enum ViewControllerType : String
    {
        case categoriesController
        case medalsController
    }
    
    var itemCategory: Int?
    
    var categories = RealmManager.retrieveItemCategories()
    lazy var medal = RealmManager.retrieveItemMedals(category: itemCategory!)
    
    var currentState: ViewControllerType = .categoriesController
    
    lazy var rewardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AwardsAndsMedalsCell.self, forCellWithReuseIdentifier: "awardsAndsMedalsCell")
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let collectionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Awards and medals", comment: "")
        
        view.backgroundColor = .mainScreenBackgroundColor
        rewardsCollectionView.delegate = self
        rewardsCollectionView.dataSource = self
        
        setupSubViews()
    }
    
    func setupSubViews() {
        setupCollectionTitle()
        setupRewardsCollectionView()
    }
    
    func setupRewardsCollectionView() {
        view.addSubview(rewardsCollectionView)
        
        let padding = LayoutConstants.screenWidth * 0.03
        
        NSLayoutConstraint.activate([
            rewardsCollectionView.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor, constant: LayoutConstants.screenHeight * 0.0287),
            rewardsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            rewardsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            rewardsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }
    
    func setupCollectionTitle() {
        view.addSubview(collectionTitle)
        
        NSLayoutConstraint.activate([
            collectionTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.16),
            collectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.024),
            collectionTitle.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.026),
            collectionTitle.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.4)
            
        ])
    }
    
}

extension AwardsAndMedalsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "awardsAndsMedalsCell", for: indexPath) as! AwardsAndsMedalsCell
        switch currentState {
        case .categoriesController:
            cell.itemCategoryViewModel = categories[indexPath.row]
        case .medalsController:
            cell.medalsViewModel = medal[indexPath.row]
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentState {
        case .categoriesController:
            return RealmManager.itemCategoriesCount
        case .medalsController:
            return RealmManager.itemMedalsCount(category: itemCategory!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2.1), height: (collectionView.frame.height / 4.5))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentState {
        case .categoriesController:
            guard let cell = collectionView.cellForItem(at: indexPath) as? AwardsAndsMedalsCell else {
                return }
            let vc = AwardsAndMedalsScreenVC()
            vc.title = NSLocalizedString("Awards and medals", comment: "")
            vc.itemCategory = cell.id
            vc.currentState = .medalsController
            vc.collectionTitle.text = NSLocalizedString("Awards and medals", comment: "")
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.screenHeight * 0.0275
    }
    
}

