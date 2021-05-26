import UIKit

class AchievementsScreenVC: MyPlanChildVC {
    
    var achievementModels: [ItemModel] = [] {
        didSet {
            achievementsCarousel.reloadData()
        }
    }
    
    let noAchievementsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("No achievements to show", comment: "")
        label.textColor = .lowContrastGray
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var achievementsCarousel: UICollectionView = {
        let layout = ZoomAndSnapFlowLayout(itemSize: carouselItemSize)
		layout.zoomFactor = 0
		layout.minimumLineSpacing = 20
		
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.delegate = self
		collectionView.dataSource = self
        
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(AchievementsCell.self, forCellWithReuseIdentifier: "achievementsCell")
        
        return collectionView
    }()
	
	let carouselItemSize = CGSize(width: LayoutConstants.screenWidth * 0.777, height: LayoutConstants.screenHeight * 0.564 )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateItemModels()
        
        if achievementModels.count == 0 {
            noAchievementsLabel.isHidden = false
        } else {
            noAchievementsLabel.isHidden = true
        }
    }
    
    func setupSubViews() {
        setupAchievementsCarousel()
        setupNoAchievementsLabel()
    }
    
    func setupNoAchievementsLabel() {
        view.addSubview(noAchievementsLabel)
        
        NSLayoutConstraint.activate([
            noAchievementsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAchievementsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noAchievementsLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.6),
            noAchievementsLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    func setupAchievementsCarousel() {
        view.addSubview(achievementsCarousel)
        
        NSLayoutConstraint.activate([
            achievementsCarousel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            achievementsCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            achievementsCarousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			achievementsCarousel.heightAnchor.constraint(equalToConstant: carouselItemSize.height)
        ])
    }
    
    func updateItemModels() {
        achievementModels = RealmManager.retrieveItems(withFilter: "type_id == \(ItemType.achievement.id)")
    }
    
}

extension AchievementsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievementsCell", for: indexPath) as! AchievementsCell
        cell.viewModel = achievementModels[indexPath.row]
        return cell
    }
	
}
